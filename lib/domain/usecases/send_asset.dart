import '../entities/asset.dart';
import '../repositories/transaction_repository.dart';

class SendAssetParams {
  final Asset asset;
  final String recipientAddress;
  final double amount;
  final double gasFee;

  const SendAssetParams({
    required this.asset,
    required this.recipientAddress,
    required this.amount,
    required this.gasFee,
  });
}

class SendAssetUseCase {
  final TransactionRepository repository;

  SendAssetUseCase(this.repository);

  Future<String> call(SendAssetParams params) async {
    return await repository.sendTransaction(
      asset: params.asset,
      recipientAddress: params.recipientAddress,
      amount: params.amount,
      gasFee: params.gasFee,
    );
  }
}
