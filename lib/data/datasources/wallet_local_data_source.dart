import 'package:bip39/bip39.dart' as bip39;
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
    return WalletModel(mnemonic: mnemonic, seed: seed);
  }

  @override
  Future<WalletModel> importWallet(String mnemonic) async {
    final cleanMnemonic = mnemonic.trim().replaceAll(RegExp(r'\s+'), ' ');
    final isValid = bip39.validateMnemonic(cleanMnemonic);
    if (!isValid) {
      throw Exception('Invalid mnemonic phrase');
    }
    final seed = bip39.mnemonicToSeedHex(cleanMnemonic);
    return WalletModel(mnemonic: cleanMnemonic, seed: seed);
  }
}
