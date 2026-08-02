import 'dart:math';

abstract class TransactionLocalDataSource {
  bool isValidAddress(String address, String assetSymbol);
  Future<double> estimateGasFee(String assetSymbol);
  Future<String> broadcastTransaction({
    required String assetSymbol,
    required String recipientAddress,
    required double amount,
    required double gasFee,
  });
}

/// Simulates chain interaction until a real RPC/node connection and fee
/// oracle are wired in.
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Random _random = Random();

  static final RegExp _btcAddressPattern = RegExp(
    r'^(1|3)[a-km-zA-HJ-NP-Z1-9]{25,34}$|^bc1[a-z0-9]{25,39}$',
  );
  static final RegExp _hexAddressPattern = RegExp(r'^0x[a-fA-F0-9]{40}$');

  @override
  bool isValidAddress(String address, String assetSymbol) {
    final trimmed = address.trim();
    if (assetSymbol == 'BTC') return _btcAddressPattern.hasMatch(trimmed);
    return _hexAddressPattern.hasMatch(trimmed);
  }

  @override
  Future<double> estimateGasFee(String assetSymbol) async {
    await Future.delayed(const Duration(milliseconds: 900));
    switch (assetSymbol) {
      case 'BTC':
        return 0.00012;
      case 'ETH':
        return 0.0021;
      case 'BNB':
        return 0.00050;
      default:
        return 1.5;
    }
  }

  @override
  Future<String> broadcastTransaction({
    required String assetSymbol,
    required String recipientAddress,
    required double amount,
    required double gasFee,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    return '0x${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
  }
}
