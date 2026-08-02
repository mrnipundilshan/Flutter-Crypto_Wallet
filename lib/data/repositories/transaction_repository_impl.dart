import '../../domain/entities/asset.dart';
import '../../domain/entities/gas_fee_estimate.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  bool isValidAddress(String address, String assetSymbol) {
    return localDataSource.isValidAddress(address, assetSymbol);
  }

  @override
  Future<GasFeeEstimate> estimateGasFee(Asset asset) async {
    final fee = await localDataSource.estimateGasFee(asset.symbol);
    return GasFeeEstimate(feeAmount: fee, feeSymbol: asset.symbol);
  }

  @override
  Future<String> sendTransaction({
    required Asset asset,
    required String recipientAddress,
    required double amount,
    required double gasFee,
  }) async {
    return await localDataSource.broadcastTransaction(
      assetSymbol: asset.symbol,
      recipientAddress: recipientAddress,
      amount: amount,
      gasFee: gasFee,
    );
  }
}
