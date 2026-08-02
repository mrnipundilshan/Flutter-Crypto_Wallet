import '../repositories/security_repository.dart';

class DeleteWalletUseCase {
  final SecurityRepository repository;

  DeleteWalletUseCase(this.repository);

  Future<void> call(String walletId) async {
    return await repository.deleteWallet(walletId);
  }
}
