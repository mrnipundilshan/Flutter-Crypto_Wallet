import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/check_biometric_availability.dart';
import '../../../domain/usecases/enable_biometric.dart';
import '../../../domain/usecases/save_wallet.dart';
import '../../../domain/usecases/set_pin.dart';
import 'set_pin_event.dart';
import 'set_pin_state.dart';

class SetPinBloc extends Bloc<SetPinEvent, SetPinState> {
  final CheckBiometricAvailabilityUseCase checkBiometricAvailabilityUseCase;
  final SaveWalletUseCase saveWalletUseCase;
  final SetPinUseCase setPinUseCase;
  final EnableBiometricUseCase enableBiometricUseCase;

  SetPinBloc({
    required this.checkBiometricAvailabilityUseCase,
    required this.saveWalletUseCase,
    required this.setPinUseCase,
    required this.enableBiometricUseCase,
  }) : super(const SetPinState()) {
    on<BiometricAvailabilityChecked>(_onBiometricAvailabilityChecked);
    on<PinSetupSubmitted>(_onPinSetupSubmitted);
  }

  Future<void> _onBiometricAvailabilityChecked(
    BiometricAvailabilityChecked event,
    Emitter<SetPinState> emit,
  ) async {
    final available = await checkBiometricAvailabilityUseCase();
    emit(state.copyWith(biometricAvailable: available));
  }

  Future<void> _onPinSetupSubmitted(
    PinSetupSubmitted event,
    Emitter<SetPinState> emit,
  ) async {
    emit(state.copyWith(status: SetPinStatus.submitting));
    try {
      await saveWalletUseCase(event.wallet);
      await setPinUseCase(event.pin);
      if (event.enableBiometric) {
        await enableBiometricUseCase();
      }
      emit(state.copyWith(status: SetPinStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: SetPinStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
