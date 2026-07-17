import '../../domain/entities/wallet.dart';

class WalletModel extends Wallet {
  const WalletModel({
    required super.mnemonic,
    required super.seed,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      mnemonic: json['mnemonic'] as String,
      seed: json['seed'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mnemonic': mnemonic,
      'seed': seed,
    };
  }
}
