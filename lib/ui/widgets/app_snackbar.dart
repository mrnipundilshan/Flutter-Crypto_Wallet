import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum SnackBarType { success, error, info }

class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);

    Color backgroundColor;
    IconData icon;
    Color iconColor;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = AppColors.positive.withValues(alpha: 0.9);
        icon = Icons.check_circle_outline;
        iconColor = Colors.white;
        break;
      case SnackBarType.error:
        backgroundColor = AppColors.negative.withValues(alpha: 0.9);
        icon = Icons.error_outline;
        iconColor = Colors.white;
        break;
      case SnackBarType.info:
        backgroundColor =
            theme.snackBarTheme.backgroundColor ?? AppColors.charcoal;
        icon = Icons.info_outline;
        iconColor = AppColors.neonCyan;
        break;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: theme.snackBarTheme.contentTextStyle),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        margin: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
