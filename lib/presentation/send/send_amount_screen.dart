import 'package:flutter/material.dart';
import '../../domain/entities/asset.dart';
import 'send_gas_estimate_screen.dart';

/// Step 3 of the send flow: enter an amount, checked against the balance.
class SendAmountScreen extends StatefulWidget {
  final Asset asset;
  final String recipientAddress;

  const SendAmountScreen({super.key, required this.asset, required this.recipientAddress});

  @override
  State<SendAmountScreen> createState() => _SendAmountScreenState();
}

class _SendAmountScreenState extends State<SendAmountScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMax() {
    _controller.text = widget.asset.balance.toString();
    setState(() => _errorText = null);
  }

  void _onContinue() {
    final amount = double.tryParse(_controller.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Enter a valid amount.');
      return;
    }
    if (amount > widget.asset.balance) {
      setState(() {
        _errorText =
            'Insufficient funds. Available: ${widget.asset.balance.toStringAsFixed(4)} ${widget.asset.symbol}.';
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SendGasEstimateScreen(
          asset: widget.asset,
          recipientAddress: widget.recipientAddress,
          amount: amount,
        ),
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
              Text('Amount', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Available: ${widget.asset.balance.toStringAsFixed(4)} ${widget.asset.symbol}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: theme.textTheme.headlineSmall,
                decoration: InputDecoration(
                  hintText: '0.0',
                  suffixText: widget.asset.symbol,
                  errorText: _errorText,
                ),
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: _onMax, child: const Text('Max')),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _onContinue, child: const Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }
}
