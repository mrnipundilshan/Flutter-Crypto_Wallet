import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/import_wallet.dart';
import 'import_wallet_event.dart';
import 'import_wallet_state.dart';

class ImportWalletBloc extends Bloc<ImportWalletEvent, ImportWalletState> {
  final ImportWalletUseCase importWalletUseCase;

  ImportWalletBloc({required this.importWalletUseCase})
      : super(ImportWalletInitial()) {
    on<ImportWalletRequested>(_onImportWalletRequested);
  }

  Future<void> _onImportWalletRequested(
    ImportWalletRequested event,
    Emitter<ImportWalletState> emit,
  ) async {
    emit(ImportWalletLoading());
    try {
      final wallet = await importWalletUseCase(event.mnemonic);
      emit(ImportWalletSuccess(wallet));
    } catch (e) {
      emit(ImportWalletFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
