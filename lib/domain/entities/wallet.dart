import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String id;
  final String name;
  final String mnemonic;
  final String seed;

  const Wallet({
    this.id = '',
    this.name = '',
    required this.mnemonic,
    required this.seed,
  });

  Wallet copyWith({String? id, String? name}) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      mnemonic: mnemonic,
      seed: seed,
    );
  }

  @override
  List<Object?> get props => [id, name, mnemonic, seed];
}
