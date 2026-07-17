import 'package:equatable/equatable.dart';

abstract class CreateWalletEvent extends Equatable {
  const CreateWalletEvent();

  @override
  List<Object?> get props => [];
}

class CreateWalletRequested extends CreateWalletEvent {}
