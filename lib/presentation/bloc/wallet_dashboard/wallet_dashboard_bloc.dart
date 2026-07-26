import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_assets.dart';
import 'wallet_dashboard_event.dart';
import 'wallet_dashboard_state.dart';

class WalletDashboardBloc extends Bloc<WalletDashboardEvent, WalletDashboardState> {
  final GetAssetsUseCase getAssetsUseCase;

  WalletDashboardBloc({required this.getAssetsUseCase}) : super(WalletDashboardLoading()) {
    on<WalletDashboardRequested>(_onWalletDashboardRequested);
  }

  Future<void> _onWalletDashboardRequested(
    WalletDashboardRequested event,
    Emitter<WalletDashboardState> emit,
  ) async {
    emit(WalletDashboardLoading());
    try {
      final assets = await getAssetsUseCase();
      emit(WalletDashboardSuccess(assets));
    } catch (e) {
      emit(WalletDashboardFailure(e.toString()));
    }
  }
}
