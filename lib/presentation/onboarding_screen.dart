import 'package:crypto_wallet/presentation/create_new_wallet.dart';
import 'package:crypto_wallet/presentation/import_wallet.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateNewWallet()),
                );
              },
              child: Text("Create New Wallet"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportWallet()),
                );
              },
              child: Text("Import Wallet"),
            ),
          ],
        ),
      ),
    );
  }
}
