import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../models/wallet_model.dart';

abstract class SecureStorageDataSource {
  Future<void> addWallet(WalletModel wallet);
  Future<List<WalletModel>> getWallets();
  Future<void> setActiveWalletId(String id);
  Future<String?> getActiveWalletId();
  Future<void> savePin(String pin);
  Future<bool> verifyPin(String pin);
  Future<bool> hasPin();
  Future<bool> isBiometricAvailable();
  Future<bool> authenticate();
  Future<void> setBiometricEnabled(bool enabled);
  Future<bool> isBiometricEnabled();
}

class SecureStorageDataSourceImpl implements SecureStorageDataSource {
  static const _walletsKey = 'wallets';
  static const _activeWalletIdKey = 'active_wallet_id';
  static const _pinHashKey = 'pin_hash';
  static const _pinSaltKey = 'pin_salt';
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _pinHashIterations = 100000;

  final FlutterSecureStorage secureStorage;
  final LocalAuthentication localAuth;

  SecureStorageDataSourceImpl({
    required this.secureStorage,
    required this.localAuth,
  });

  @override
  Future<void> addWallet(WalletModel wallet) async {
    final wallets = await getWallets();
    final index = wallets.indexWhere((w) => w.id == wallet.id);
    if (index >= 0) {
      wallets[index] = wallet;
    } else {
      wallets.add(wallet);
    }
    final json = jsonEncode(wallets.map((w) => w.toJson()).toList());
    await secureStorage.write(key: _walletsKey, value: json);
  }

  @override
  Future<List<WalletModel>> getWallets() async {
    final raw = await secureStorage.read(key: _walletsKey);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => WalletModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> setActiveWalletId(String id) async {
    await secureStorage.write(key: _activeWalletIdKey, value: id);
  }

  @override
  Future<String?> getActiveWalletId() async {
    return await secureStorage.read(key: _activeWalletIdKey);
  }

  @override
  Future<void> savePin(String pin) async {
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await secureStorage.write(key: _pinSaltKey, value: salt);
    await secureStorage.write(key: _pinHashKey, value: hash);
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final salt = await secureStorage.read(key: _pinSaltKey);
    final storedHash = await secureStorage.read(key: _pinHashKey);
    if (salt == null || storedHash == null) return false;
    return _hashPin(pin, salt) == storedHash;
  }

  @override
  Future<bool> hasPin() async {
    final storedHash = await secureStorage.read(key: _pinHashKey);
    return storedHash != null && storedHash.isNotEmpty;
  }

  @override
  Future<bool> isBiometricAvailable() async {
    final canCheck = await localAuth.canCheckBiometrics;
    final isSupported = await localAuth.isDeviceSupported();
    return canCheck && isSupported;
  }

  @override
  Future<bool> authenticate() async {
    return await localAuth.authenticate(
      localizedReason: 'Confirm your identity to unlock your wallet',
      biometricOnly: true,
    );
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await secureStorage.write(
      key: _biometricEnabledKey,
      value: enabled.toString(),
    );
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final value = await secureStorage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  String _generateSalt() {
    final random = Random.secure();
    final bytes = Uint8List.fromList(List.generate(16, (_) => random.nextInt(256)));
    return base64Url.encode(bytes);
  }

  /// Iterated HMAC-SHA256 (PBKDF2-style) so a stolen hash resists brute-forcing.
  String _hashPin(String pin, String salt) {
    List<int> digest = utf8.encode(pin + salt);
    for (var i = 0; i < _pinHashIterations; i++) {
      digest = Hmac(sha256, utf8.encode(salt)).convert(digest).bytes;
    }
    return base64Url.encode(digest);
  }
}
