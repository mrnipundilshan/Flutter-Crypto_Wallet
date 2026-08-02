import 'package:flutter/material.dart';
import '../../domain/entities/asset.dart';
import '../../domain/usecases/validate_recipient_address.dart';
import '../../injection_container.dart';
import 'send_amount_screen.dart';

/// Step 2 of the send flow: enter and validate the recipient address.
class SendRecipientScreen extends StatefulWidget {
  final Asset asset;

  const SendRecipientScreen({super.key, required this.asset});

  @override
  State<SendRecipientScreen> createState() => _SendRecipientScreenState();
}

class _SendRecipientScreenState extends State<SendRecipientScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onContinue() {
    final address = _controller.text.trim();
    if (address.isEmpty) {
      setState(() => _errorText = 'Enter a recipient address.');
      return;
    }

    final isValid = sl<ValidateRecipientAddressUseCase>()(address, widget.asset.symbol);
    if (!isValid) {
      setState(() => _errorText = "That doesn't look like a valid ${widget.asset.symbol} address.");
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SendAmountScreen(asset: widget.asset, recipientAddress: address),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Send ${widget.asset.symbol}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Recipient Address', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Enter the wallet address that will receive your ${widget.asset.symbol}.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                maxLines: 3,
                style: theme.textTheme.bodyLarge?.copyWith(fontFamily: 'monospace'),
                decoration: InputDecoration(
                  hintText: widget.asset.symbol == 'BTC' ? 'bc1...' : '0x...',
                  errorText: _errorText,
                ),
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _onContinue, child: const Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }
}
