import 'package:flutter/material.dart';

/// A 3x4 numeric keypad (0-9, backspace) used for PIN entry.
class NumericKeypad extends StatelessWidget {
  final ValueChanged<String> onDigitTap;
  final VoidCallback onBackspace;

  const NumericKeypad({
    super.key,
    required this.onDigitTap,
    required this.onBackspace,
  });

  static const _layout = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', 'backspace'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _layout.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((key) => _buildKey(context, key)).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildKey(BuildContext context, String key) {
    final theme = Theme.of(context);

    if (key.isEmpty) {
      return const SizedBox(width: 72, height: 64);
    }

    if (key == 'backspace') {
      return SizedBox(
        width: 72,
        height: 64,
        child: IconButton(
          onPressed: onBackspace,
          icon: Icon(Icons.backspace_outlined, color: theme.colorScheme.onSurface),
        ),
      );
    }

    return SizedBox(
      width: 72,
      height: 64,
      child: TextButton(
        onPressed: () => onDigitTap(key),
        child: Text(
          key,
          style: theme.textTheme.headlineSmall,
        ),
      ),
    );
  }
}
