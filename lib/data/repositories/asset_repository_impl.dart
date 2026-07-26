import '../../domain/entities/asset.dart';
import '../../domain/repositories/asset_repository.dart';
import '../datasources/asset_local_data_source.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetLocalDataSource localDataSource;

  AssetRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Asset>> getAssets() async {
    return await localDataSource.getAssets();
  }
}
