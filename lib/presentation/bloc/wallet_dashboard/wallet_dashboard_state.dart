import 'package:equatable/equatable.dart';
import '../../../domain/entities/asset.dart';

abstract class WalletDashboardState extends Equatable {
  const WalletDashboardState();

  @override
  List<Object?> get props => [];
}

class WalletDashboardLoading extends WalletDashboardState {}

class WalletDashboardSuccess extends WalletDashboardState {
  final List<Asset> assets;

  const WalletDashboardSuccess(this.assets);

  double get totalBalance => assets.fold(0, (sum, asset) => sum + asset.usdValue);

  @override
  List<Object?> get props => [assets];
}

class WalletDashboardFailure extends WalletDashboardState {
  final String message;

  const WalletDashboardFailure(this.message);

  @override
  List<Object?> get props => [message];
}
