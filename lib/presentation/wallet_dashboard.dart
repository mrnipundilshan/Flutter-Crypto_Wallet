import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/wallet.dart';
import '../injection_container.dart';
import 'bloc/wallet_dashboard/wallet_dashboard_bloc.dart';
import 'bloc/wallet_dashboard/wallet_dashboard_event.dart';
import 'bloc/wallet_dashboard/wallet_dashboard_state.dart';
import 'create_new_wallet.dart';
import 'import_wallet.dart';
import 'widgets/asset_tile.dart';
import 'widgets/balance_card.dart';
import '../core/theme/app_colors.dart';

class WalletDashboard extends StatelessWidget {
  const WalletDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletDashboardBloc>(
      create: (_) => sl<WalletDashboardBloc>()..add(WalletDashboardRequested()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Wallet'),
              actions: [
                IconButton(
                  tooltip: 'Switch wallet',
                  icon: const Icon(Icons.account_balance_wallet_outlined),
                  onPressed: () => _showWalletSwitcher(context),
                ),
              ],
            ),
            body: SafeArea(
              child: BlocBuilder<WalletDashboardBloc, WalletDashboardState>(
                builder: (context, state) {
                  if (state is WalletDashboardSuccess) {
                    return _DashboardView(state: state);
                  } else if (state is WalletDashboardFailure) {
                    return _FailureView(message: state.message);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

void _showWalletSwitcher(BuildContext context) {
  final bloc = context.read<WalletDashboardBloc>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: bloc,
        child: _WalletSwitcherSheet(
          onAddWallet: (screen) async {
            Navigator.pop(sheetContext);
            final saved = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => screen),
            );
            if (saved == true) {
              bloc.add(WalletDashboardRequested());
            }
          },
        ),
      );
    },
  );
}

class _WalletSwitcherSheet extends StatelessWidget {
  final void Function(Widget screen) onAddWallet;

  const _WalletSwitcherSheet({required this.onAddWallet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<WalletDashboardBloc, WalletDashboardState>(
          builder: (context, state) {
            final wallets = state is WalletDashboardSuccess ? state.wallets : const <Wallet>[];
            final activeId = state is WalletDashboardSuccess ? state.activeWallet.id : null;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Your Wallets', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                for (final wallet in wallets)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      wallet.id == activeId ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: AppColors.primary,
                    ),
                    title: Text(wallet.name),
                    onTap: () {
                      if (wallet.id != activeId) {
                        context.read<WalletDashboardBloc>().add(WalletSwitched(wallet.id));
                      }
                      Navigator.pop(context);
                    },
                  ),
                const Divider(height: 32),
                ElevatedButton(
                  onPressed: () => onAddWallet(const CreateNewWallet(fromDashboard: true)),
                  child: const Text('Create New Wallet'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => onAddWallet(const ImportWallet(fromDashboard: true)),
                  child: const Text('Import Wallet'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  final WalletDashboardSuccess state;

  const _DashboardView({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<WalletDashboardBloc>().add(WalletDashboardRequested());
      },
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(state.activeWallet.name, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          BalanceCard(totalUsdValue: state.totalBalance),
          const SizedBox(height: 24),
          Text('Assets', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final asset in state.assets) ...[
            AssetTile(asset: asset),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  final String message;

  const _FailureView({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
            const SizedBox(height: 16),
            Text('Could not load your assets', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<WalletDashboardBloc>().add(WalletDashboardRequested());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
