import 'package:flutter/material.dart';

/// Shows [length] dots, filling the first [filledCount] to reflect PIN entry progress.
class PinDotsIndicator extends StatelessWidget {
  final int length;
  final int filledCount;

  const PinDotsIndicator({
    super.key,
    required this.length,
    required this.filledCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final isFilled = i < filledCount;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? theme.colorScheme.primary : Colors.transparent,
            border: Border.all(color: theme.colorScheme.primary, width: 1.5),
          ),
        );
      }),
    );
  }
}
