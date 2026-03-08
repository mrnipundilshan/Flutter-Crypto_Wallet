import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/neon_button.dart';
import '../mock_data.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Receive'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // ── QR Code Card ──
                GlassCard(
                      padding: const EdgeInsets.all(28),
                      borderRadius: 24,
                      child: Column(
                        children: [
                          Text(
                            'Scan to pay',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: QrImageView(
                              data: MockData.walletAddress,
                              version: QrVersions.auto,
                              size: 200,
                              backgroundColor: Colors.white,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.circle,
                                color: AppColors.deepIndigo,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.circle,
                                color: AppColors.deepIndigo,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Your Wallet Address',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.glassFill,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${MockData.walletAddress.substring(0, 12)}...${MockData.walletAddress.substring(MockData.walletAddress.length - 8)}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontFamily: 'monospace',
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      const ClipboardData(
                                        text: MockData.walletAddress,
                                      ),
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Address copied!',
                                          ),
                                          backgroundColor: AppColors.charcoal,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    CupertinoIcons.doc_on_doc,
                                    color: AppColors.neonCyan,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scaleXY(begin: 0.9, end: 1, curve: Curves.easeOutCubic),

                const SizedBox(height: 32),

                // ── Action Buttons ──
                NeonButton(
                  label: 'Copy Address',
                  icon: CupertinoIcons.doc_on_doc_fill,
                  onPressed: () async {
                    await Clipboard.setData(
                      const ClipboardData(text: MockData.walletAddress),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Address copied to clipboard!'),
                          backgroundColor: AppColors.charcoal,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 14),

                NeonOutlineButton(
                  label: 'Share Address',
                  icon: CupertinoIcons.share,
                  borderColor: AppColors.neonPurple,
                  onPressed: () {
                    // Share action placeholder
                  },
                ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
