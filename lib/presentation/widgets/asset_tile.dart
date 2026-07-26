import 'package:flutter/material.dart';
import '../../domain/entities/asset.dart';

/// A single row showing an asset's symbol, holdings, and USD value.
class AssetTile extends StatelessWidget {
  final Asset asset;

  const AssetTile({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: Text(
              asset.symbol.substring(0, 1),
              style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  '${asset.balance.toStringAsFixed(4)} ${asset.symbol}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Text(
            '\$${asset.usdValue.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
