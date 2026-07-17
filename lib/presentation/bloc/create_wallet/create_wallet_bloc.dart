import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/create_wallet.dart';
import 'create_wallet_event.dart';
import 'create_wallet_state.dart';

class CreateWalletBloc extends Bloc<CreateWalletEvent, CreateWalletState> {
  final CreateWalletUseCase createWalletUseCase;

  CreateWalletBloc({required this.createWalletUseCase})
      : super(CreateWalletInitial()) {
    on<CreateWalletRequested>(_onCreateWalletRequested);
  }

  Future<void> _onCreateWalletRequested(
    CreateWalletRequested event,
    Emitter<CreateWalletState> emit,
  ) async {
    emit(CreateWalletLoading());
    try {
      final wallet = await createWalletUseCase();
      emit(CreateWalletSuccess(wallet));
    } catch (e) {
      emit(CreateWalletFailure(e.toString()));
    }
  }
}
