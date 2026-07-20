import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../injection_container.dart';
import 'bloc/import_wallet/import_wallet_bloc.dart';
import 'bloc/import_wallet/import_wallet_event.dart';
import 'bloc/import_wallet/import_wallet_state.dart';
import 'widgets/mnemonic_card.dart';
import '../core/theme/app_colors.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});

  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  final TextEditingController _mnemonicController = TextEditingController();

  @override
  void dispose() {
    _mnemonicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider<ImportWalletBloc>(
      create: (_) => sl<ImportWalletBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Import Wallet')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<ImportWalletBloc, ImportWalletState>(
              listener: (context, state) {
                if (state is ImportWalletSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wallet imported successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (state is ImportWalletFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is ImportWalletLoading;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Enter Recovery Phrase', style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your 12 or 24-word recovery phrase, separated by spaces, to restore your wallet.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _mnemonicController,
                        maxLines: 4,
                        enabled: !isLoading,
                        style: theme.textTheme.bodyLarge?.copyWith(fontFamily: 'monospace'),
                        decoration: const InputDecoration(
                          hintText: 'word1 word2 word3 ...',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                final mnemonic = _mnemonicController.text.trim();
                                if (mnemonic.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Recovery phrase cannot be empty.'),
                                      backgroundColor: AppColors.warning,
                                    ),
                                  );
                                  return;
                                }
                                context.read<ImportWalletBloc>().add(
                                      ImportWalletRequested(mnemonic),
                                    );
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Import Wallet'),
                      ),
                      if (state is ImportWalletSuccess) ...[
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
                            const SizedBox(width: 8),
                            Text('Wallet Restored', style: theme.textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 16),
                        MnemonicCard(mnemonic: state.wallet.mnemonic),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
