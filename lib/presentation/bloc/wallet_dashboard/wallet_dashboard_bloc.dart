import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/clear_pin.dart';
import '../../../domain/usecases/delete_wallet.dart';
import '../../../domain/usecases/get_active_wallet.dart';
import '../../../domain/usecases/get_assets.dart';
import '../../../domain/usecases/get_wallets.dart';
import '../../../domain/usecases/switch_wallet.dart';
import 'wallet_dashboard_event.dart';
import 'wallet_dashboard_state.dart';

class WalletDashboardBloc extends Bloc<WalletDashboardEvent, WalletDashboardState> {
  final GetAssetsUseCase getAssetsUseCase;
  final GetWalletsUseCase getWalletsUseCase;
  final GetActiveWalletUseCase getActiveWalletUseCase;
  final SwitchWalletUseCase switchWalletUseCase;
  final DeleteWalletUseCase deleteWalletUseCase;
  final ClearPinUseCase clearPinUseCase;

  WalletDashboardBloc({
    required this.getAssetsUseCase,
    required this.getWalletsUseCase,
    required this.getActiveWalletUseCase,
    required this.switchWalletUseCase,
    required this.deleteWalletUseCase,
    required this.clearPinUseCase,
  }) : super(WalletDashboardLoading()) {
    on<WalletDashboardRequested>(_onWalletDashboardRequested);
    on<WalletSwitched>(_onWalletSwitched);
    on<WalletRemoved>(_onWalletRemoved);
  }

  Future<void> _onWalletDashboardRequested(
    WalletDashboardRequested event,
    Emitter<WalletDashboardState> emit,
  ) async {
    emit(WalletDashboardLoading());
    await _loadDashboard(emit);
  }

  Future<void> _onWalletSwitched(
    WalletSwitched event,
    Emitter<WalletDashboardState> emit,
  ) async {
    emit(WalletDashboardLoading());
    try {
      await switchWalletUseCase(event.walletId);
      await _loadDashboard(emit);
    } catch (e) {
      emit(WalletDashboardFailure(e.toString()));
    }
  }

  Future<void> _onWalletRemoved(
    WalletRemoved event,
    Emitter<WalletDashboardState> emit,
  ) async {
    emit(WalletDashboardLoading());
    try {
      await deleteWalletUseCase(event.walletId);
      final remaining = await getWalletsUseCase();
      if (remaining.isEmpty) {
        await clearPinUseCase();
        emit(WalletDashboardEmpty());
        return;
      }
      await _loadDashboard(emit);
    } catch (e) {
      emit(WalletDashboardFailure(e.toString()));
    }
  }

  Future<void> _loadDashboard(Emitter<WalletDashboardState> emit) async {
    try {
      final wallets = await getWalletsUseCase();
      final activeWallet = await getActiveWalletUseCase();
      if (activeWallet == null) {
        emit(const WalletDashboardFailure('No wallet found on this device.'));
        return;
      }
      final assets = await getAssetsUseCase();
      emit(WalletDashboardSuccess(assets: assets, activeWallet: activeWallet, wallets: wallets));
    } catch (e) {
      emit(WalletDashboardFailure(e.toString()));
    }
  }
}
