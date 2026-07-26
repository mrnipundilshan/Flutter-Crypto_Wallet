import '../repositories/security_repository.dart';

class EnableBiometricUseCase {
  final SecurityRepository repository;

  EnableBiometricUseCase(this.repository);

  Future<bool> call() async {
    return await repository.enableBiometric();
  }
}
