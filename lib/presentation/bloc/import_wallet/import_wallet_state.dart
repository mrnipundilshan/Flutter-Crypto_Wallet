import 'package:equatable/equatable.dart';
import '../../../../domain/entities/wallet.dart';

abstract class ImportWalletState extends Equatable {
  const ImportWalletState();

  @override
  List<Object?> get props => [];
}

class ImportWalletInitial extends ImportWalletState {}

class ImportWalletLoading extends ImportWalletState {}

class ImportWalletSuccess extends ImportWalletState {
  final Wallet wallet;

  const ImportWalletSuccess(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class ImportWalletFailure extends ImportWalletState {
  final String message;

  const ImportWalletFailure(this.message);

  @override
  List<Object?> get props => [message];
}
