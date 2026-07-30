import '../entities/wallet.dart';
import '../repositories/security_repository.dart';

class SaveWalletUseCase {
  final SecurityRepository repository;

  SaveWalletUseCase(this.repository);

  Future<Wallet> call(Wallet wallet) async {
    return await repository.saveWallet(wallet);
  }
}
