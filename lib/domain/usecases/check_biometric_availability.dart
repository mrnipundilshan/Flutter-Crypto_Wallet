import '../repositories/security_repository.dart';

class CheckBiometricAvailabilityUseCase {
  final SecurityRepository repository;

  CheckBiometricAvailabilityUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isBiometricAvailable();
  }
}
