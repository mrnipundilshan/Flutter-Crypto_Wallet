import '../entities/asset.dart';
import '../entities/gas_fee_estimate.dart';
import '../repositories/transaction_repository.dart';

class EstimateGasFeeUseCase {
  final TransactionRepository repository;

  EstimateGasFeeUseCase(this.repository);

  Future<GasFeeEstimate> call(Asset asset) async {
    return await repository.estimateGasFee(asset);
  }
}
