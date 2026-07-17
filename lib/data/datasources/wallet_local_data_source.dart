import 'package:bip39/bip39.dart' as bip39;
import '../models/wallet_model.dart';

abstract class WalletLocalDataSource {
  Future<WalletModel> createWallet();
}

class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  @override
  Future<WalletModel> createWallet() async {
    final mnemonic = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeedHex(mnemonic);
    return WalletModel(mnemonic: mnemonic, seed: seed);
  }
}
