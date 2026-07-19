import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../injection_container.dart';
import 'bloc/create_wallet/create_wallet_bloc.dart';
import 'bloc/create_wallet/create_wallet_event.dart';
import 'bloc/create_wallet/create_wallet_state.dart';

class CreateNewWallet extends StatelessWidget {
  const CreateNewWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateWalletBloc>(
      create: (_) => sl<CreateWalletBloc>()..add(CreateWalletRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create New Wallet'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<CreateWalletBloc, CreateWalletState>(
              builder: (context, state) {
                if (state is CreateWalletLoading || state is CreateWalletInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is CreateWalletSuccess) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Wallet Created Successfully!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Mnemonic Phrase:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.wallet.mnemonic,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              tooltip: 'Copy Mnemonic Phrase',
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: state.wallet.mnemonic),
                                ).then((_) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Mnemonic phrase copied to clipboard'),
                                    ),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<CreateWalletBloc>()
                              .add(CreateWalletRequested());
                        },
                        child: const Text('Generate Another Wallet'),
                      ),
                    ],
                  );
                } else if (state is CreateWalletFailure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Failed to create wallet:\n${state.message}',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<CreateWalletBloc>()
                              .add(CreateWalletRequested());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  );
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
