import '../entities/wallet.dart';
import '../repositories/security_repository.dart';

class GetActiveWalletUseCase {
  final SecurityRepository repository;

  GetActiveWalletUseCase(this.repository);

  Future<Wallet?> call() async {
    return await repository.getActiveWallet();
  }
}
