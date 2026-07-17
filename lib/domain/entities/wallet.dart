import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String mnemonic;
  final String seed;

  const Wallet({
    required this.mnemonic,
    required this.seed,
  });

  @override
  List<Object?> get props => [mnemonic, seed];
}
