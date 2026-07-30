import '../repositories/security_repository.dart';

class HasPinUseCase {
  final SecurityRepository repository;

  HasPinUseCase(this.repository);

  Future<bool> call() async {
    return await repository.hasPin();
  }
}
