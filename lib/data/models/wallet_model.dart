import '../../domain/entities/wallet.dart';

class WalletModel extends Wallet {
  const WalletModel({
    required super.id,
    required super.name,
    required super.mnemonic,
    required super.seed,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mnemonic: json['mnemonic'] as String,
      seed: json['seed'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mnemonic': mnemonic,
      'seed': seed,
    };
  }
}
