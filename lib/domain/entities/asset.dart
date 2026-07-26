import 'package:equatable/equatable.dart';

class Asset extends Equatable {
  final String symbol;
  final String name;
  final double balance;
  final double usdPrice;

  const Asset({
    required this.symbol,
    required this.name,
    required this.balance,
    required this.usdPrice,
  });

  double get usdValue => balance * usdPrice;

  @override
  List<Object?> get props => [symbol, name, balance, usdPrice];
}
