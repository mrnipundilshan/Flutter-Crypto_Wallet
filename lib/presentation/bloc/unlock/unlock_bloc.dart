import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/is_biometric_enabled.dart';
import '../../../domain/usecases/unlock_with_biometric.dart';
import '../../../domain/usecases/verify_pin.dart';
import 'unlock_event.dart';
import 'unlock_state.dart';

class UnlockBloc extends Bloc<UnlockEvent, UnlockState> {
  final IsBiometricEnabledUseCase isBiometricEnabledUseCase;
  final VerifyPinUseCase verifyPinUseCase;
  final UnlockWithBiometricUseCase unlockWithBiometricUseCase;

  UnlockBloc({
    required this.isBiometricEnabledUseCase,
    required this.verifyPinUseCase,
    required this.unlockWithBiometricUseCase,
  }) : super(const UnlockState()) {
    on<UnlockStarted>(_onUnlockStarted);
    on<UnlockPinSubmitted>(_onPinSubmitted);
    on<UnlockBiometricRequested>(_onBiometricRequested);
  }

  Future<void> _onUnlockStarted(UnlockStarted event, Emitter<UnlockState> emit) async {
    final enabled = await isBiometricEnabledUseCase();
    emit(state.copyWith(biometricEnabled: enabled));
  }

  Future<void> _onPinSubmitted(UnlockPinSubmitted event, Emitter<UnlockState> emit) async {
    emit(state.copyWith(status: UnlockStatus.submitting));
    final isValid = await verifyPinUseCase(event.pin);
    if (isValid) {
      emit(state.copyWith(status: UnlockStatus.success));
    } else {
      emit(state.copyWith(
        status: UnlockStatus.failure,
        errorMessage: 'Incorrect PIN. Try again.',
      ));
    }
  }

  Future<void> _onBiometricRequested(UnlockBiometricRequested event, Emitter<UnlockState> emit) async {
    try {
      final success = await unlockWithBiometricUseCase();
      if (success) {
        emit(state.copyWith(status: UnlockStatus.success));
      }
    } catch (_) {
      // Ignore; the user can still unlock with their PIN.
    }
  }
}
