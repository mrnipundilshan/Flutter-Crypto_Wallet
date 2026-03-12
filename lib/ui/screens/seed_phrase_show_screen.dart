import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/neon_button.dart';
import 'import_wallet_screen.dart';

class SeedPhraseShowScreen extends StatefulWidget {
  const SeedPhraseShowScreen({super.key});

  @override
  State<SeedPhraseShowScreen> createState() => _SeedPhraseShowScreenState();
}

class _SeedPhraseShowScreenState extends State<SeedPhraseShowScreen> {
  List<String> seedPhrases = [];
  bool isCopied = false;

  @override
  void initState() {
    super.initState();
    createSeed();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 50),
                SizedBox(
                  height: 450.h,
                  child: GridView.builder(
                    itemCount: 12,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3,
                    ),
                    itemBuilder: (context, index) {
                      return SeedPhraseCard(seedPhrase: seedPhrases[index]);
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  "Warning: Never share your seed phrase with anyone. Anyone who has your seed phrase can steal your funds.",
                ),
              ],
            ),

            Column(
              children: [
                SizedBox(height: 20),
                _buildButtons(
                  context,
                  "Copy Seed Phrases",
                  CupertinoIcons.arrow_down_doc,
                  () {
                    isCopied = true;
                    Clipboard.setData(
                      ClipboardData(text: seedPhrases.join(" ")),
                    );
                    AppSnackBar.show(
                      context,
                      message: "Seed phrases copied to clipboard",
                      type: SnackBarType.success,
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildButtons(context, "Next", CupertinoIcons.arrow_right, () {
                  if (!isCopied) {
                    AppSnackBar.show(
                      context,
                      message: "Please copy seed phrases first",
                      type: SnackBarType.error,
                    );
                    return;
                  }
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
                }),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void createSeed() {
    String mnemonic = bip39.generateMnemonic();
    seedPhrases = mnemonic.split(' ');
  }

  Widget _buildButtons(
    BuildContext context,
    String label,
    IconData icon,
    Function onPressed,
  ) {
    return NeonOutlineButton(
          label: label,
          icon: icon,
          onPressed: () {
            onPressed();
          },
        )
        .animate()
        .fadeIn(delay: 650.ms, duration: 600.ms)
        .slideY(begin: 0.4, end: 0, curve: Curves.easeOutCubic);
  }
}

class SeedPhraseCard extends StatelessWidget {
  const SeedPhraseCard({super.key, required this.seedPhrase});

  final String seedPhrase;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 150.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neonCyan),
        color: AppColors.neonCyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20.sp,
            color: Colors.white,
          ),
          seedPhrase,
        ),
      ),
    );
  }
}
