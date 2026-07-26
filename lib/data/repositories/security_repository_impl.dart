import '../../domain/entities/wallet.dart';
import '../../domain/repositories/security_repository.dart';
import '../datasources/secure_storage_data_source.dart';
import '../models/wallet_model.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  final SecureStorageDataSource dataSource;

  SecurityRepositoryImpl({required this.dataSource});

  @override
  Future<void> saveWallet(Wallet wallet) async {
    await dataSource.saveWallet(
      WalletModel(mnemonic: wallet.mnemonic, seed: wallet.seed),
    );
  }

  @override
  Future<void> setPin(String pin) async {
    await dataSource.savePin(pin);
  }

  @override
  Future<bool> isBiometricAvailable() async {
    return await dataSource.isBiometricAvailable();
  }

  @override
  Future<bool> enableBiometric() async {
    final authenticated = await dataSource.authenticate();
    if (authenticated) {
      await dataSource.setBiometricEnabled(true);
    }
    return authenticated;
  }
}
