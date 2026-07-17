import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<Wallet> createWallet();
}
