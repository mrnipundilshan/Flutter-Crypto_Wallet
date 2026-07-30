import '../repositories/security_repository.dart';

class IsBiometricEnabledUseCase {
  final SecurityRepository repository;

  IsBiometricEnabledUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isBiometricEnabled();
  }
}
