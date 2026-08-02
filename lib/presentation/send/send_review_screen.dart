import 'package:flutter/material.dart';
import '../../domain/entities/asset.dart';
import 'send_confirm_screen.dart';

/// Step 5 of the send flow: review the full transaction before signing.
/// "Edit" loops back to the recipient step, matching the send flow diagram.
class SendReviewScreen extends StatelessWidget {
  final Asset asset;
  final String recipientAddress;
  final double amount;
  final double gasFee;

  const SendReviewScreen({
    super.key,
    required this.asset,
    required this.recipientAddress,
    required this.amount,
    required this.gasFee,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = amount + gasFee;

    return Scaffold(
      appBar: AppBar(title: const Text('Review Transaction')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  children: [
                    _ReviewRow(label: 'Recipient', value: recipientAddress, monospace: true),
                    const Divider(height: 28),
                    _ReviewRow(label: 'Amount', value: '${amount.toStringAsFixed(6)} ${asset.symbol}'),
                    const Divider(height: 28),
                    _ReviewRow(label: 'Network Fee', value: '${gasFee.toStringAsFixed(6)} ${asset.symbol}'),
                    const Divider(height: 28),
                    _ReviewRow(
                      label: 'Total',
                      value: '${total.toStringAsFixed(6)} ${asset.symbol}',
                      emphasize: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '≈ \$${(total * asset.usdPrice).toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () => Navigator.of(context).popUntil(ModalRoute.withName('/send/recipient')),
                child: const Text('Edit'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SendConfirmScreen(
                        asset: asset,
                        recipientAddress: recipientAddress,
                        amount: amount,
                        gasFee: gasFee,
                      ),
                    ),
                  );
                },
                child: const Text('Confirm and Sign'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool monospace;
  final bool emphasize;

  const _ReviewRow({
    required this.label,
    required this.value,
    this.monospace = false,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: (emphasize ? theme.textTheme.titleMedium : theme.textTheme.bodyLarge)?.copyWith(
              fontFamily: monospace ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}
