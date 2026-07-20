import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays a mnemonic phrase as numbered word chips with a copy action.
class MnemonicCard extends StatelessWidget {
  final String mnemonic;

  const MnemonicCard({super.key, required this.mnemonic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final words = mnemonic.trim().split(RegExp(r'\s+'));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Recovery Phrase',
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.copy_rounded, color: theme.colorScheme.primary, size: 20),
                tooltip: 'Copy recovery phrase',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: mnemonic));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recovery phrase copied to clipboard')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(words.length, (i) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${i + 1}  ',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: words[i],
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
