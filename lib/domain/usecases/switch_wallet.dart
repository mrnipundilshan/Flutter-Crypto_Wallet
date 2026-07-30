import '../repositories/security_repository.dart';

class SwitchWalletUseCase {
  final SecurityRepository repository;

  SwitchWalletUseCase(this.repository);

  Future<void> call(String walletId) async {
    return await repository.setActiveWallet(walletId);
  }
}
