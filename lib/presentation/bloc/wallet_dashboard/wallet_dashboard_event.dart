import 'package:equatable/equatable.dart';

abstract class WalletDashboardEvent extends Equatable {
  const WalletDashboardEvent();

  @override
  List<Object?> get props => [];
}

class WalletDashboardRequested extends WalletDashboardEvent {}

class WalletSwitched extends WalletDashboardEvent {
  final String walletId;

  const WalletSwitched(this.walletId);

  @override
  List<Object?> get props => [walletId];
}

class WalletRemoved extends WalletDashboardEvent {
  final String walletId;

  const WalletRemoved(this.walletId);

  @override
  List<Object?> get props => [walletId];
}
