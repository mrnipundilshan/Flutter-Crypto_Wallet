import 'package:equatable/equatable.dart';

abstract class SendConfirmEvent extends Equatable {
  const SendConfirmEvent();

  @override
  List<Object?> get props => [];
}

class SendConfirmStarted extends SendConfirmEvent {}

class SendConfirmPinSubmitted extends SendConfirmEvent {
  final String pin;

  const SendConfirmPinSubmitted(this.pin);

  @override
  List<Object?> get props => [pin];
}

class SendConfirmBiometricRequested extends SendConfirmEvent {}
