import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<Wallet> createWallet();
  Future<Wallet> importWallet(String mnemonic);
}
