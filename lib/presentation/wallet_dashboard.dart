import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../injection_container.dart';
import 'bloc/wallet_dashboard/wallet_dashboard_bloc.dart';
import 'bloc/wallet_dashboard/wallet_dashboard_event.dart';
import 'bloc/wallet_dashboard/wallet_dashboard_state.dart';
import 'widgets/asset_tile.dart';
import 'widgets/balance_card.dart';
import '../core/theme/app_colors.dart';

class WalletDashboard extends StatelessWidget {
  const WalletDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletDashboardBloc>(
      create: (_) => sl<WalletDashboardBloc>()..add(WalletDashboardRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Wallet')),
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
