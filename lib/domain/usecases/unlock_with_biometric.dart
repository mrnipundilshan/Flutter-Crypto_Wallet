import '../repositories/security_repository.dart';

class UnlockWithBiometricUseCase {
  final SecurityRepository repository;

  UnlockWithBiometricUseCase(this.repository);

  Future<bool> call() async {
    return await repository.unlockWithBiometric();
  }
}
