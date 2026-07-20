import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../injection_container.dart';
import 'bloc/create_wallet/create_wallet_bloc.dart';
import 'bloc/create_wallet/create_wallet_event.dart';
import 'bloc/create_wallet/create_wallet_state.dart';
import 'widgets/mnemonic_card.dart';
import 'widgets/warning_banner.dart';
import '../core/theme/app_colors.dart';

class CreateNewWallet extends StatelessWidget {
  const CreateNewWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateWalletBloc>(
      create: (_) => sl<CreateWalletBloc>()..add(CreateWalletRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Wallet')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<CreateWalletBloc, CreateWalletState>(
              builder: (context, state) {
                if (state is CreateWalletLoading || state is CreateWalletInitial) {
                  return const _LoadingView();
                } else if (state is CreateWalletSuccess) {
                  return _SuccessView(mnemonic: state.wallet.mnemonic);
                } else if (state is CreateWalletFailure) {
                  return _FailureView(message: state.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: 20),
          Text('Generating your wallet...', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final String mnemonic;

  const _SuccessView({required this.mnemonic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: AppColors.success, size: 40),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Wallet Created!',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Write down these words in order and keep them somewhere safe.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          MnemonicCard(mnemonic: mnemonic),
          const SizedBox(height: 16),
          const WarningBanner(
            message: 'Never share your recovery phrase with anyone. '
                'Anyone with these words can access your funds.',
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.read<CreateWalletBloc>().add(CreateWalletRequested());
            },
            child: const Text('Generate Another Wallet'),
          ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, color: AppColors.error, size: 40),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to create wallet',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<CreateWalletBloc>().add(CreateWalletRequested());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
