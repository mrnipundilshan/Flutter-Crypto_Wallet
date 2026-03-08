import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/neon_button.dart';
import 'dashboard_screen.dart';
import 'import_wallet_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Logo / Hero ──
              _buildHero(context),

              const Spacer(flex: 3),

              // ── CTA Buttons ──
              _buildButtons(context),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Column(
      children: [
        // Animated wallet icon with glow
        Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.neonGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonCyan.withValues(alpha: 0.4),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.creditcard,
                size: 52,
                color: AppColors.deepIndigo,
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(
              begin: 1.0,
              end: 1.05,
              duration: 2000.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .shimmer(
              duration: 1500.ms,
              color: Colors.white.withValues(alpha: 0.15),
            ),

        const SizedBox(height: 36),

        Text(
          'CryptoVault',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

        const SizedBox(height: 12),

        Text(
          'Your gateway to decentralized finance.\nSecure. Private. Yours.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(height: 1.6, fontSize: 15),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        NeonButton(
              label: 'Create New Wallet',
              icon: CupertinoIcons.plus_circle_fill,
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context1, animation1, animation2) =>
                        const DashboardScreen(),
                    transitionsBuilder: (context2, anim, animation3, child) {
                      return FadeTransition(
                        opacity: CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeOut,
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              },
            )
            .animate()
            .fadeIn(delay: 500.ms, duration: 600.ms)
            .slideY(begin: 0.4, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 16),

        NeonOutlineButton(
              label: 'Import Wallet',
              icon: CupertinoIcons.arrow_down_doc,
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context1, animation1, animation2) =>
                        const ImportWalletScreen(),
                    transitionsBuilder: (context2, anim, animation3, child) {
                      return FadeTransition(
                        opacity: CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeOut,
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              },
            )
            .animate()
            .fadeIn(delay: 650.ms, duration: 600.ms)
            .slideY(begin: 0.4, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }
}
