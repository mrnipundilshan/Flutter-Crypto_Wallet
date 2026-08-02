import '../../domain/entities/wallet.dart';
import '../../domain/repositories/security_repository.dart';
import '../datasources/secure_storage_data_source.dart';
import '../models/wallet_model.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  final SecureStorageDataSource dataSource;

  SecurityRepositoryImpl({required this.dataSource});

  @override
  Future<Wallet> saveWallet(Wallet wallet) async {
    final existing = await dataSource.getWallets();
    final duplicateIndex = existing.indexWhere((w) => w.id == wallet.id);
    final name = wallet.name.isNotEmpty
        ? wallet.name
        : duplicateIndex >= 0
            ? existing[duplicateIndex].name
            : 'Wallet ${existing.length + 1}';

    final model = WalletModel(
      id: wallet.id,
      name: name,
      mnemonic: wallet.mnemonic,
      seed: wallet.seed,
    );
    await dataSource.addWallet(model);
    await dataSource.setActiveWalletId(model.id);
    return model;
  }

  @override
  Future<List<Wallet>> getWallets() async {
    return await dataSource.getWallets();
  }

  @override
  Future<void> deleteWallet(String walletId) async {
    await dataSource.deleteWallet(walletId);
  }

  @override
  Future<Wallet?> getActiveWallet() async {
    final wallets = await dataSource.getWallets();
    if (wallets.isEmpty) return null;

    final activeId = await dataSource.getActiveWalletId();
    return wallets.firstWhere(
      (w) => w.id == activeId,
      orElse: () => wallets.first,
    );
  }

  @override
  Future<void> setActiveWallet(String walletId) async {
    await dataSource.setActiveWalletId(walletId);
  }

  @override
  Future<void> setPin(String pin) async {
    await dataSource.savePin(pin);
  }

  @override
  Future<bool> verifyPin(String pin) async {
    return await dataSource.verifyPin(pin);
  }

  @override
  Future<bool> hasPin() async {
    return await dataSource.hasPin();
  }

  @override
  Future<void> clearPin() async {
    await dataSource.clearPin();
  }

  @override
  Future<bool> isBiometricAvailable() async {
    return await dataSource.isBiometricAvailable();
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return await dataSource.isBiometricEnabled();
  }

  @override
  Future<bool> enableBiometric() async {
    final authenticated = await dataSource.authenticate();
    if (authenticated) {
      await dataSource.setBiometricEnabled(true);
    }
    return authenticated;
  }

  @override
  Future<bool> unlockWithBiometric() async {
    return await dataSource.authenticate();
  }
}
