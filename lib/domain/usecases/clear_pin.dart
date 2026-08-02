import '../repositories/security_repository.dart';

class ClearPinUseCase {
  final SecurityRepository repository;

  ClearPinUseCase(this.repository);

  Future<void> call() async {
    return await repository.clearPin();
  }
}
