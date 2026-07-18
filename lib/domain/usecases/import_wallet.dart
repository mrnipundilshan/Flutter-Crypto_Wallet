import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class ImportWalletUseCase {
  final WalletRepository repository;

  ImportWalletUseCase(this.repository);

  Future<Wallet> call(String mnemonic) async {
    return await repository.importWallet(mnemonic);
  }
}
