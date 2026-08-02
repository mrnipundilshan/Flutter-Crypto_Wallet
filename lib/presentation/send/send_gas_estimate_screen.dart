import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/asset.dart';
import '../../domain/usecases/estimate_gas_fee.dart';
import '../../injection_container.dart';
import 'send_review_screen.dart';

/// Step 4 of the send flow: queries the network fee rate, then continues
/// automatically to the review screen.
class SendGasEstimateScreen extends StatefulWidget {
  final Asset asset;
  final String recipientAddress;
  final double amount;

  const SendGasEstimateScreen({
    super.key,
    required this.asset,
    required this.recipientAddress,
    required this.amount,
  });

  @override
  State<SendGasEstimateScreen> createState() => _SendGasEstimateScreenState();
}

class _SendGasEstimateScreenState extends State<SendGasEstimateScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _estimate();
  }

  Future<void> _estimate() async {
    try {
      final estimate = await sl<EstimateGasFeeUseCase>()(widget.asset);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SendReviewScreen(
            asset: widget.asset,
            recipientAddress: widget.recipientAddress,
            amount: widget.amount,
            gasFee: estimate.feeAmount,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Failed to estimate the network fee: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Send ${widget.asset.symbol}')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _error == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text('Estimating network fee...', style: theme.textTheme.bodyMedium),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _error = null);
                          _estimate();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
