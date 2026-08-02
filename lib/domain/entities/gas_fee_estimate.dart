import 'package:equatable/equatable.dart';

class GasFeeEstimate extends Equatable {
  final double feeAmount;
  final String feeSymbol;

  const GasFeeEstimate({required this.feeAmount, required this.feeSymbol});

  @override
  List<Object?> get props => [feeAmount, feeSymbol];
}
