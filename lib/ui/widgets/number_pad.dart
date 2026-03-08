import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';

class NumberPad extends StatelessWidget {
  final ValueChanged<String> onNumberTap;
  final VoidCallback onDeleteTap;
  final VoidCallback? onDotTap;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onDeleteTap,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.8,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        ...[
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
        ].map((n) => _buildKey(n.toString(), () => onNumberTap(n.toString()))),
        _buildKey('.', () {
          if (onDotTap != null) {
            onDotTap!();
          } else {
            onNumberTap('.');
          }
        }),
        _buildKey('0', () => onNumberTap('0')),
        _buildDeleteKey(),
      ],
    );
  }

  Widget _buildKey(String label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.neonCyan.withValues(alpha: 0.15),
        highlightColor: AppColors.neonCyan.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder, width: 0.5),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onDeleteTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.negative.withValues(alpha: 0.15),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder, width: 0.5),
          ),
          child: const Center(
            child: Icon(
              CupertinoIcons.delete_left,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
