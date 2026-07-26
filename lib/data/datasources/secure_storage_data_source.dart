import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../models/wallet_model.dart';

abstract class SecureStorageDataSource {
  Future<void> saveWallet(WalletModel wallet);
  Future<void> savePin(String pin);
  Future<bool> isBiometricAvailable();
  Future<bool> authenticate();
  Future<void> setBiometricEnabled(bool enabled);
}

class SecureStorageDataSourceImpl implements SecureStorageDataSource {
  static const _mnemonicKey = 'wallet_mnemonic';
  static const _seedKey = 'wallet_seed';
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
  Future<void> saveWallet(WalletModel wallet) async {
    await secureStorage.write(key: _mnemonicKey, value: wallet.mnemonic);
    await secureStorage.write(key: _seedKey, value: wallet.seed);
  }

  @override
  Future<void> savePin(String pin) async {
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await secureStorage.write(key: _pinSaltKey, value: salt);
    await secureStorage.write(key: _pinHashKey, value: hash);
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
      localizedReason: 'Confirm your identity to enable biometric unlock',
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
