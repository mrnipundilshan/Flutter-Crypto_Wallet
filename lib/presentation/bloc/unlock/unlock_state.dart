import 'package:equatable/equatable.dart';

enum UnlockStatus { initial, submitting, success, failure }

class UnlockState extends Equatable {
  final UnlockStatus status;
  final bool biometricEnabled;
  final String? errorMessage;

  const UnlockState({
    this.status = UnlockStatus.initial,
    this.biometricEnabled = false,
    this.errorMessage,
  });

  UnlockState copyWith({
    UnlockStatus? status,
    bool? biometricEnabled,
    String? errorMessage,
  }) {
    return UnlockState(
      status: status ?? this.status,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, biometricEnabled, errorMessage];
}
