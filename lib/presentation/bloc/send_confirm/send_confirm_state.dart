import 'package:equatable/equatable.dart';

enum SendConfirmStatus { initial, submitting, broadcasting, success, failure }

class SendConfirmState extends Equatable {
  final SendConfirmStatus status;
  final bool biometricEnabled;
  final String? errorMessage;
  final String? txHash;

  const SendConfirmState({
    this.status = SendConfirmStatus.initial,
    this.biometricEnabled = false,
    this.errorMessage,
    this.txHash,
  });

  SendConfirmState copyWith({
    SendConfirmStatus? status,
    bool? biometricEnabled,
    String? errorMessage,
    String? txHash,
  }) {
    return SendConfirmState(
      status: status ?? this.status,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      errorMessage: errorMessage,
      txHash: txHash ?? this.txHash,
    );
  }

  @override
  List<Object?> get props => [status, biometricEnabled, errorMessage, txHash];
}
