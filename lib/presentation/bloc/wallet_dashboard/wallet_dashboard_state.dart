import 'package:equatable/equatable.dart';
import '../../../domain/entities/asset.dart';
import '../../../domain/entities/wallet.dart';

abstract class WalletDashboardState extends Equatable {
  const WalletDashboardState();

  @override
  List<Object?> get props => [];
}

class WalletDashboardLoading extends WalletDashboardState {}

/// Every wallet on this device has been removed; the UI should return to
/// onboarding so the user can create or import a wallet to continue.
class WalletDashboardEmpty extends WalletDashboardState {}

class WalletDashboardSuccess extends WalletDashboardState {
  final List<Asset> assets;
  final Wallet activeWallet;
  final List<Wallet> wallets;

  const WalletDashboardSuccess({
    required this.assets,
    required this.activeWallet,
    required this.wallets,
  });

  double get totalBalance => assets.fold(0, (sum, asset) => sum + asset.usdValue);

  @override
  List<Object?> get props => [assets, activeWallet, wallets];
}

class WalletDashboardFailure extends WalletDashboardState {
  final String message;

  const WalletDashboardFailure(this.message);

  @override
  List<Object?> get props => [message];
}
