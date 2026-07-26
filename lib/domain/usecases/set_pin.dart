import '../repositories/security_repository.dart';

class SetPinUseCase {
  final SecurityRepository repository;

  SetPinUseCase(this.repository);

  Future<void> call(String pin) async {
    return await repository.setPin(pin);
  }
}
