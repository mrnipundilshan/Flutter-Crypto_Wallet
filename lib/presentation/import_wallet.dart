import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../injection_container.dart';
import 'bloc/import_wallet/import_wallet_bloc.dart';
import 'bloc/import_wallet/import_wallet_event.dart';
import 'bloc/import_wallet/import_wallet_state.dart';

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
    return BlocProvider<ImportWalletBloc>(
      create: (_) => sl<ImportWalletBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Import Wallet'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<ImportWalletBloc, ImportWalletState>(
              listener: (context, state) {
                if (state is ImportWalletSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wallet imported successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is ImportWalletFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Enter Mnemonic Phrase',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please enter your 12 or 24-word recovery phrase, separated by spaces.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _mnemonicController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'word1 word2 word3 ...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (state is ImportWalletLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        ElevatedButton(
                          onPressed: () {
                            final mnemonic = _mnemonicController.text.trim();
                            if (mnemonic.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mnemonic phrase cannot be empty.'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }
                            context.read<ImportWalletBloc>().add(
                                  ImportWalletRequested(mnemonic),
                                );
                          },
                          child: const Text('Import Wallet'),
                        ),
                      const SizedBox(height: 32),
                      if (state is ImportWalletSuccess) ...[
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          'Imported Wallet Details:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Mnemonic:',
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
