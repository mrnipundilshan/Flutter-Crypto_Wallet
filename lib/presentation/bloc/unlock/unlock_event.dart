import 'package:equatable/equatable.dart';

abstract class UnlockEvent extends Equatable {
  const UnlockEvent();

  @override
  List<Object?> get props => [];
}

class UnlockStarted extends UnlockEvent {}

class UnlockPinSubmitted extends UnlockEvent {
  final String pin;

  const UnlockPinSubmitted(this.pin);

  @override
  List<Object?> get props => [pin];
}

class UnlockBiometricRequested extends UnlockEvent {}
