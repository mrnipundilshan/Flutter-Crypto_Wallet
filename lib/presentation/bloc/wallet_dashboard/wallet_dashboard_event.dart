import 'package:equatable/equatable.dart';

abstract class WalletDashboardEvent extends Equatable {
  const WalletDashboardEvent();

  @override
  List<Object?> get props => [];
}

class WalletDashboardRequested extends WalletDashboardEvent {}
