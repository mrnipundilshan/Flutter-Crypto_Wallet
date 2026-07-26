import '../../domain/entities/asset.dart';

abstract class AssetLocalDataSource {
  Future<List<Asset>> getAssets();
}

/// Placeholder asset list until live balances/prices are wired to a chain
/// indexer or price feed. A freshly created/imported wallet holds nothing yet.
class AssetLocalDataSourceImpl implements AssetLocalDataSource {
  @override
  Future<List<Asset>> getAssets() async {
    return const [
      Asset(symbol: 'BTC', name: 'Bitcoin', balance: 0, usdPrice: 65000),
      Asset(symbol: 'ETH', name: 'Ethereum', balance: 0, usdPrice: 3400),
      Asset(symbol: 'USDT', name: 'Tether', balance: 0, usdPrice: 1),
      Asset(symbol: 'BNB', name: 'BNB', balance: 0, usdPrice: 580),
    ];
  }
}
