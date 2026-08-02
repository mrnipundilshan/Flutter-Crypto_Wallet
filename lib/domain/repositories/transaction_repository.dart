import '../entities/asset.dart';
import '../entities/gas_fee_estimate.dart';

abstract class TransactionRepository {
  /// Validates that [address] matches the expected format for [assetSymbol].
  bool isValidAddress(String address, String assetSymbol);

  /// Queries the current network fee rate for sending [asset].
  Future<GasFeeEstimate> estimateGasFee(Asset asset);

  /// Signs and broadcasts a transaction, returning the resulting tx hash.
  Future<String> sendTransaction({
    required Asset asset,
    required String recipientAddress,
    required double amount,
    required double gasFee,
  });
}
