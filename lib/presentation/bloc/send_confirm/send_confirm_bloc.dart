import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/is_biometric_enabled.dart';
import '../../../domain/usecases/send_asset.dart';
import '../../../domain/usecases/unlock_with_biometric.dart';
import '../../../domain/usecases/verify_pin.dart';
import 'send_confirm_event.dart';
import 'send_confirm_state.dart';

class SendConfirmBloc extends Bloc<SendConfirmEvent, SendConfirmState> {
  final IsBiometricEnabledUseCase isBiometricEnabledUseCase;
  final VerifyPinUseCase verifyPinUseCase;
  final UnlockWithBiometricUseCase unlockWithBiometricUseCase;
  final SendAssetUseCase sendAssetUseCase;
  final SendAssetParams params;

  SendConfirmBloc({
    required this.isBiometricEnabledUseCase,
    required this.verifyPinUseCase,
    required this.unlockWithBiometricUseCase,
    required this.sendAssetUseCase,
    required this.params,
  }) : super(const SendConfirmState()) {
    on<SendConfirmStarted>(_onStarted);
    on<SendConfirmPinSubmitted>(_onPinSubmitted);
    on<SendConfirmBiometricRequested>(_onBiometricRequested);
  }

  Future<void> _onStarted(SendConfirmStarted event, Emitter<SendConfirmState> emit) async {
    final enabled = await isBiometricEnabledUseCase();
    emit(state.copyWith(biometricEnabled: enabled));
  }

  Future<void> _onPinSubmitted(SendConfirmPinSubmitted event, Emitter<SendConfirmState> emit) async {
    emit(state.copyWith(status: SendConfirmStatus.submitting));
    final isValid = await verifyPinUseCase(event.pin);
    if (!isValid) {
      emit(state.copyWith(
        status: SendConfirmStatus.failure,
        errorMessage: 'Incorrect PIN. Try again.',
      ));
      return;
    }
    await _broadcast(emit);
  }

  Future<void> _onBiometricRequested(SendConfirmBiometricRequested event, Emitter<SendConfirmState> emit) async {
    try {
      final success = await unlockWithBiometricUseCase();
      if (success) {
        await _broadcast(emit);
      }
    } catch (_) {
      // Ignore; the user can still confirm with their PIN.
    }
  }

  Future<void> _broadcast(Emitter<SendConfirmState> emit) async {
    emit(state.copyWith(status: SendConfirmStatus.broadcasting));
    try {
      final txHash = await sendAssetUseCase(params);
      emit(state.copyWith(status: SendConfirmStatus.success, txHash: txHash));
    } catch (e) {
      emit(state.copyWith(
        status: SendConfirmStatus.failure,
        errorMessage: 'Failed to broadcast transaction: $e',
      ));
    }
  }
}
