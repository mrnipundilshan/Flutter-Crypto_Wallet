import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/asset.dart';
import '../../domain/usecases/send_asset.dart';
import '../../injection_container.dart';
import '../bloc/send_confirm/send_confirm_bloc.dart';
import '../bloc/send_confirm/send_confirm_event.dart';
import '../bloc/send_confirm/send_confirm_state.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/pin_dots_indicator.dart';
import 'send_success_screen.dart';

const _pinLength = 6;

/// Steps 6 and 7 of the send flow: authorize with PIN or biometric, then
/// broadcast the signed transaction to the network.
class SendConfirmScreen extends StatelessWidget {
  final Asset asset;
  final String recipientAddress;
  final double amount;
  final double gasFee;

  const SendConfirmScreen({
    super.key,
    required this.asset,
    required this.recipientAddress,
    required this.amount,
    required this.gasFee,
  });

  @override
  Widget build(BuildContext context) {
    final params = SendAssetParams(
      asset: asset,
      recipientAddress: recipientAddress,
      amount: amount,
      gasFee: gasFee,
    );

    return BlocProvider<SendConfirmBloc>(
      create: (_) => SendConfirmBloc(
        isBiometricEnabledUseCase: sl(),
        verifyPinUseCase: sl(),
        unlockWithBiometricUseCase: sl(),
        sendAssetUseCase: sl(),
        params: params,
      )..add(SendConfirmStarted()),
      child: const _SendConfirmView(),
    );
  }
}

class _SendConfirmView extends StatefulWidget {
  const _SendConfirmView();

  @override
  State<_SendConfirmView> createState() => _SendConfirmViewState();
}

class _SendConfirmViewState extends State<_SendConfirmView> {
  String _enteredPin = '';

  void _onDigitTap(String digit) {
    if (_enteredPin.length >= _pinLength) return;

    setState(() => _enteredPin += digit);
    if (_enteredPin.length == _pinLength) {
      context.read<SendConfirmBloc>().add(SendConfirmPinSubmitted(_enteredPin));
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty) return;
    setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SendConfirmBloc, SendConfirmState>(
      listener: (context, state) {
        if (state.status == SendConfirmStatus.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => SendSuccessScreen(txHash: state.txHash!)),
            (route) => route.isFirst,
          );
        } else if (state.status == SendConfirmStatus.failure) {
          setState(() => _enteredPin = '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Confirm and Sign')),
        body: SafeArea(
          child: BlocBuilder<SendConfirmBloc, SendConfirmState>(
            builder: (context, state) {
              if (state.status == SendConfirmStatus.broadcasting) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text('Broadcasting to network...', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock_rounded, color: AppColors.primary, size: 48),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Enter your PIN to sign',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Authorize this transaction to broadcast it to the network.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 40),
                    PinDotsIndicator(length: _pinLength, filledCount: _enteredPin.length),
                    const Spacer(),
                    NumericKeypad(onDigitTap: _onDigitTap, onBackspace: _onBackspace),
                    const SizedBox(height: 12),
                    if (state.biometricEnabled)
                      Center(
                        child: TextButton.icon(
                          onPressed: () => context.read<SendConfirmBloc>().add(SendConfirmBiometricRequested()),
                          icon: const Icon(Icons.fingerprint_rounded),
                          label: const Text('Use biometric'),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
