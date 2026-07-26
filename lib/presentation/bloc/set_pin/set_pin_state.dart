import 'package:equatable/equatable.dart';

enum SetPinStatus { initial, submitting, success, failure }

class SetPinState extends Equatable {
  final SetPinStatus status;
  final bool biometricAvailable;
  final String? errorMessage;

  const SetPinState({
    this.status = SetPinStatus.initial,
    this.biometricAvailable = false,
    this.errorMessage,
  });

  SetPinState copyWith({
    SetPinStatus? status,
    bool? biometricAvailable,
    String? errorMessage,
  }) {
    return SetPinState(
      status: status ?? this.status,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, biometricAvailable, errorMessage];
}
