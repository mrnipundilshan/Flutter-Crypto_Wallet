import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/neon_button.dart';
import '../widgets/number_pad.dart';
import '../mock_data.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  String _amount = '0';
  CoinData _selectedCoin = MockData.coins[0];
  final TextEditingController _addressController = TextEditingController();

  void _onNumberTap(String value) {
    setState(() {
      if (_amount == '0' && value != '.') {
        _amount = value;
      } else {
        if (value == '.' && _amount.contains('.')) return;
        _amount += value;
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = '0';
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Send'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ── Asset Picker ──
              _buildAssetPicker(context),

              const SizedBox(height: 24),

              // ── Amount Display ──
              _buildAmountDisplay(context),

              const SizedBox(height: 24),

              // ── Address Input ──
              _buildAddressInput(context),

              const SizedBox(height: 28),

              // ── Number Pad ──
              NumberPad(
                onNumberTap: _onNumberTap,
                onDeleteTap: _onDelete,
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

              const SizedBox(height: 20),

              // ── Send Button ──
              NeonButton(
                label: 'Send ${_selectedCoin.symbol}',
                icon: CupertinoIcons.paperplane_fill,
                onPressed: () {
                  _showSentDialog(context);
                },
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssetPicker(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 16,
      child: InkWell(
        onTap: () => _showAssetPicker(context),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedCoin.accentColor.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  _selectedCoin.iconChar,
                  style: TextStyle(
                    fontSize: 18,
                    color: _selectedCoin.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCoin.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_selectedCoin.holdings} ${_selectedCoin.symbol}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              CupertinoIcons.chevron_down,
              color: AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15, end: 0);
  }

  Widget _buildAmountDisplay(BuildContext context) {
    final usdValue = double.tryParse(_amount) ?? 0;
    final usd = usdValue * _selectedCoin.price;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _amount,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _selectedCoin.symbol,
                style: TextStyle(
                  color: _selectedCoin.accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '≈ \$${usd.toStringAsFixed(2)}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 15),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms);
  }

  Widget _buildAddressInput(BuildContext context) {
    return TextField(
      controller: _addressController,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Recipient address',
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Icon(
            CupertinoIcons.person_circle,
            color: AppColors.textMuted,
            size: 22,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: const Icon(
              CupertinoIcons.qrcode_viewfinder,
              color: AppColors.neonCyan,
              size: 22,
            ),
            onPressed: () {
              // QR scan placeholder
            },
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 500.ms);
  }

  void _showAssetPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String search = '';
        return StatefulBuilder(
          builder: (ctx2, setSheetState) {
            final filtered = MockData.coins.where((c) {
              return c.name.toLowerCase().contains(search.toLowerCase()) ||
                  c.symbol.toLowerCase().contains(search.toLowerCase());
            }).toList();

            return Container(
              decoration: const BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.glassBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: const TextStyle(color: AppColors.textPrimary),
                    onChanged: (v) => setSheetState(() => search = v),
                    decoration: const InputDecoration(
                      hintText: 'Search asset...',
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...filtered.map((coin) {
                    return ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: coin.accentColor.withValues(alpha: 0.2),
                        ),
                        child: Center(
                          child: Text(
                            coin.iconChar,
                            style: TextStyle(
                              color: coin.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        coin.name,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        '${coin.holdings} ${coin.symbol}',
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                      trailing: Text(
                        '\$${coin.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      onTap: () {
                        setState(() => _selectedCoin = coin);
                        Navigator.pop(ctx);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.charcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.positive.withValues(alpha: 0.15),
              ),
              child: const Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: AppColors.positive,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transaction Sent',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_amount ${_selectedCoin.symbol}',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
