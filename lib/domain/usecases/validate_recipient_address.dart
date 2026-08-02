import '../repositories/transaction_repository.dart';

class ValidateRecipientAddressUseCase {
  final TransactionRepository repository;

  ValidateRecipientAddressUseCase(this.repository);

  bool call(String address, String assetSymbol) {
    return repository.isValidAddress(address, assetSymbol);
  }
}
