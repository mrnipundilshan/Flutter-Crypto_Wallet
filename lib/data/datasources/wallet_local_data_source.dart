import 'dart:convert';

import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto/crypto.dart';
import '../models/wallet_model.dart';

abstract class WalletLocalDataSource {
  Future<WalletModel> createWallet();
  Future<WalletModel> importWallet(String mnemonic);
}

class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  @override
  Future<WalletModel> createWallet() async {
    final mnemonic = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeedHex(mnemonic);
    return WalletModel(id: _deriveId(seed), name: '', mnemonic: mnemonic, seed: seed);
  }

  @override
  Future<WalletModel> importWallet(String mnemonic) async {
    final cleanMnemonic = mnemonic.trim().replaceAll(RegExp(r'\s+'), ' ');
    final isValid = bip39.validateMnemonic(cleanMnemonic);
    if (!isValid) {
      throw Exception('Invalid mnemonic phrase');
    }
    final seed = bip39.mnemonicToSeedHex(cleanMnemonic);
    return WalletModel(id: _deriveId(seed), name: '', mnemonic: cleanMnemonic, seed: seed);
  }

  /// Derives a stable wallet identifier from its seed so the same wallet
  /// always resolves to the same id, letting re-imports be recognized as duplicates.
  String _deriveId(String seed) {
    return sha256.convert(utf8.encode(seed)).toString().substring(0, 16);
  }
}
