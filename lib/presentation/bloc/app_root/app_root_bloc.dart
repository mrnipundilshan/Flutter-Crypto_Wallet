import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/has_pin.dart';
import 'app_root_event.dart';
import 'app_root_state.dart';

class AppRootBloc extends Bloc<AppRootEvent, AppRootState> {
  final HasPinUseCase hasPinUseCase;

  AppRootBloc({required this.hasPinUseCase}) : super(const AppRootState()) {
    on<AppStartupRequested>(_onAppStartupRequested);
  }

  Future<void> _onAppStartupRequested(
    AppStartupRequested event,
    Emitter<AppRootState> emit,
  ) async {
    final hasPin = await hasPinUseCase();
    emit(AppRootState(
      status: hasPin ? AppRootStatus.needsUnlock : AppRootStatus.needsOnboarding,
    ));
  }
}
