import 'package:equatable/equatable.dart';
import '../../../../domain/entities/wallet.dart';

abstract class CreateWalletState extends Equatable {
  const CreateWalletState();

  @override
  List<Object?> get props => [];
}

class CreateWalletInitial extends CreateWalletState {}

class CreateWalletLoading extends CreateWalletState {}

class CreateWalletSuccess extends CreateWalletState {
  final Wallet wallet;

  const CreateWalletSuccess(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class CreateWalletFailure extends CreateWalletState {
  final String message;

  const CreateWalletFailure(this.message);

  @override
  List<Object?> get props => [message];
}
