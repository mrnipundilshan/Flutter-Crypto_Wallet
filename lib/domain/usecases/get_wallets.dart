import '../entities/wallet.dart';
import '../repositories/security_repository.dart';

class GetWalletsUseCase {
  final SecurityRepository repository;

  GetWalletsUseCase(this.repository);

  Future<List<Wallet>> call() async {
    return await repository.getWallets();
  }
}
