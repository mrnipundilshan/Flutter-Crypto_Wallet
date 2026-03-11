import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/onboarding_screen.dart';

void main() {
  runApp(const CryptoWalletApp());
}

class CryptoWalletApp extends StatelessWidget {
  const CryptoWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'CryptoVault',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const OnboardingScreen(),
        );
      },
    );
  }
}
