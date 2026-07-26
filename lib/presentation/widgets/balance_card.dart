import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Displays the wallet's total balance in USD as a gradient hero card.
class BalanceCard extends StatelessWidget {
  final double totalUsdValue;

  const BalanceCard({super.key, required this.totalUsdValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalUsdValue.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
