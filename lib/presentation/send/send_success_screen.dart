import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Final step: confirms the signed transaction was broadcast successfully.
class SendSuccessScreen extends StatelessWidget {
  final String txHash;

  const SendSuccessScreen({super.key, required this.txHash});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 48),
              ),
              const SizedBox(height: 24),
              Text('Transaction Sent', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Your transaction has been broadcast to the network.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction Hash', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Text(txHash, style: theme.textTheme.bodyLarge?.copyWith(fontFamily: 'monospace')),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
