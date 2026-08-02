import 'package:flutter/material.dart';
import '../../domain/entities/asset.dart';
import '../widgets/asset_tile.dart';
import 'send_recipient_screen.dart';

/// Step 1 of the send flow: choose which asset to send.
class SendSelectAssetScreen extends StatelessWidget {
  final List<Asset> assets;

  const SendSelectAssetScreen({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Asset')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: assets.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final asset = assets[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      settings: const RouteSettings(name: '/send/recipient'),
                      builder: (_) => SendRecipientScreen(asset: asset),
                    ),
                  );
                },
                child: AssetTile(asset: asset),
              ),
            );
          },
        ),
      ),
    );
  }
}
