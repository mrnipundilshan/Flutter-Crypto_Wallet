import 'package:equatable/equatable.dart';
import '../../../domain/entities/wallet.dart';

abstract class SetPinEvent extends Equatable {
  const SetPinEvent();

  @override
  List<Object?> get props => [];
}

class BiometricAvailabilityChecked extends SetPinEvent {}

class PinSetupSubmitted extends SetPinEvent {
  final Wallet wallet;
  final String pin;
  final bool enableBiometric;

  const PinSetupSubmitted({
    required this.wallet,
    required this.pin,
    required this.enableBiometric,
  });

  @override
  List<Object?> get props => [wallet, pin, enableBiometric];
}
