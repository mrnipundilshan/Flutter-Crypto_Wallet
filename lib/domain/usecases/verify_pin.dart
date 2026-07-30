import '../repositories/security_repository.dart';

class VerifyPinUseCase {
  final SecurityRepository repository;

  VerifyPinUseCase(this.repository);

  Future<bool> call(String pin) async {
    return await repository.verifyPin(pin);
  }
}
