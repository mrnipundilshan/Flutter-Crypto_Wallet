import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class CreateWalletUseCase {
  final WalletRepository repository;

  CreateWalletUseCase(this.repository);

  Future<Wallet> call() async {
    return await repository.createWallet();
  }
}
