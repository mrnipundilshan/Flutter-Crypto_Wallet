import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/sparkline_chart.dart';
import '../mock_data.dart';
import 'send_screen.dart';
import 'receive_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.neonGradient,
              ),
              child: const Icon(
                CupertinoIcons.creditcard,
                size: 18,
                color: AppColors.deepIndigo,
              ),
            ),
            const SizedBox(width: 12),
            Text('CryptoVault', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.bell, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.settings, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── Balance Card ──
              _buildBalanceCard(context),

              const SizedBox(height: 28),

              // ── Quick Actions ──
              _buildQuickActions(context),

              const SizedBox(height: 28),

              // ── Coins Section ──
              Text(
                'Your Assets',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 18),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 16),

              _buildCoinsList(),

              const SizedBox(height: 28),

              // ── Recent Activity ──
              Text(
                'Recent Activity',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 18),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 16),

              _buildActivityList(context),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${MockData.totalBalance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.positive.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.arrow_up_right,
                          size: 12,
                          color: AppColors.positive,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${MockData.totalChangePercent}%',
                          style: const TextStyle(
                            color: AppColors.positive,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Mini sparkline for overall portfolio
              SparklineWidget(
                data: const [
                  22000,
                  22500,
                  22200,
                  23000,
                  23500,
                  23200,
                  24000,
                  23800,
                  24200,
                  24500,
                  24300,
                  24563,
                ],
                color: AppColors.neonGreen,
                height: 50,
                width: double.infinity,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: CupertinoIcons.arrow_up_circle_fill,
            label: 'Send',
            color: AppColors.neonCyan,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SendScreen())),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: CupertinoIcons.arrow_down_circle_fill,
            label: 'Receive',
            color: AppColors.neonGreen,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ReceiveScreen())),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: CupertinoIcons.arrow_right_arrow_left_circle_fill,
            label: 'Swap',
            color: AppColors.neonPurple,
            onTap: () {},
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms);
  }

  Widget _buildCoinsList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: MockData.coins.length,
        itemBuilder: (context, index) {
          final coin = MockData.coins[index];
          return _CoinCard(coin: coin)
              .animate()
              .fadeIn(delay: (500 + index * 100).ms, duration: 500.ms)
              .slideX(begin: 0.3, end: 0);
        },
      ),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    return Column(
      children: List.generate(MockData.recentTransactions.length, (index) {
        final tx = MockData.recentTransactions[index];
        return _TransactionTile(transaction: tx)
            .animate()
            .fadeIn(delay: (700 + index * 80).ms, duration: 400.ms)
            .slideX(begin: 0.15, end: 0);
      }),
    );
  }
}

// ── Quick Action Button ──
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      borderRadius: 16,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Coin Card ──
class _CoinCard extends StatelessWidget {
  final CoinData coin;

  const _CoinCard({required this.coin});

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.changePercent >= 0;

    return Container(
      width: 165,
      margin: const EdgeInsets.only(right: 14),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: coin.accentColor.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: Text(
                      coin.iconChar,
                      style: TextStyle(
                        fontSize: 18,
                        color: coin.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (isPositive ? AppColors.positive : AppColors.negative)
                            .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${coin.changePercent}%',
                    style: TextStyle(
                      color: isPositive
                          ? AppColors.positive
                          : AppColors.negative,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SparklineWidget(
              data: coin.sparkline,
              color: coin.accentColor,
              height: 35,
              width: 130,
            ),
            const Spacer(),
            Text(
              coin.symbol,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '\$${coin.price.toStringAsFixed(2)}',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Transaction Tile ──
class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        borderRadius: 14,
        opacity: 0.06,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    (transaction.isIncoming
                            ? AppColors.positive
                            : AppColors.negative)
                        .withValues(alpha: 0.12),
              ),
              child: Icon(
                transaction.icon,
                color: transaction.isIncoming
                    ? AppColors.positive
                    : AppColors.negative,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    transaction.subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.isIncoming ? '+' : '-'}${transaction.amount}',
                  style: TextStyle(
                    color: transaction.isIncoming
                        ? AppColors.positive
                        : AppColors.negative,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.time,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
