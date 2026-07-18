import 'package:equatable/equatable.dart';

abstract class ImportWalletEvent extends Equatable {
  const ImportWalletEvent();

  @override
  List<Object?> get props => [];
}

class ImportWalletRequested extends ImportWalletEvent {
  final String mnemonic;

  const ImportWalletRequested(this.mnemonic);

  @override
  List<Object?> get props => [mnemonic];
}
