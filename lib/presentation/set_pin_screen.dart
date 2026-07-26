import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/wallet.dart';
import '../injection_container.dart';
import 'bloc/set_pin/set_pin_bloc.dart';
import 'bloc/set_pin/set_pin_event.dart';
import 'bloc/set_pin/set_pin_state.dart';
import 'wallet_dashboard.dart';
import 'widgets/numeric_keypad.dart';
import 'widgets/pin_dots_indicator.dart';
import '../core/theme/app_colors.dart';

const _pinLength = 6;

enum _SetPinStage { enter, confirm, biometric }

class SetPinScreen extends StatelessWidget {
  final Wallet wallet;

  const SetPinScreen({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SetPinBloc>(
      create: (_) => sl<SetPinBloc>()..add(BiometricAvailabilityChecked()),
      child: _SetPinView(wallet: wallet),
    );
  }
}

class _SetPinView extends StatefulWidget {
  final Wallet wallet;

  const _SetPinView({required this.wallet});

  @override
  State<_SetPinView> createState() => _SetPinViewState();
}

class _SetPinViewState extends State<_SetPinView> {
  _SetPinStage _stage = _SetPinStage.enter;
  String _firstPin = '';
  String _enteredPin = '';
  bool _enableBiometric = true;

  void _onDigitTap(String digit) {
    if (_enteredPin.length >= _pinLength) return;

    setState(() => _enteredPin += digit);
    if (_enteredPin.length == _pinLength) {
      _onPinComplete();
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty) return;
    setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
  }

  void _onPinComplete() {
    if (_stage == _SetPinStage.enter) {
      setState(() {
        _firstPin = _enteredPin;
        _enteredPin = '';
        _stage = _SetPinStage.confirm;
      });
      return;
    }

    if (_enteredPin != _firstPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PINs do not match. Try again.'),
          backgroundColor: AppColors.error,
        ),
      );
      setState(() {
        _firstPin = '';
        _enteredPin = '';
        _stage = _SetPinStage.enter;
      });
      return;
    }

    final biometricAvailable = context.read<SetPinBloc>().state.biometricAvailable;
    if (biometricAvailable) {
      setState(() => _stage = _SetPinStage.biometric);
    } else {
      _submit();
    }
  }

  void _submit() {
    context.read<SetPinBloc>().add(
          PinSetupSubmitted(
            wallet: widget.wallet,
            pin: _firstPin,
            enableBiometric: _enableBiometric,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SetPinBloc, SetPinState>(
      listener: (context, state) {
        if (state.status == SetPinStatus.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WalletDashboard()),
            (route) => false,
          );
        } else if (state.status == SetPinStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to secure wallet.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Secure Your Wallet')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _stage == _SetPinStage.biometric
                ? _BiometricStep(
                    enableBiometric: _enableBiometric,
                    onChanged: (value) => setState(() => _enableBiometric = value),
                    onContinue: _submit,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        _stage == _SetPinStage.enter ? 'Create a PIN' : 'Confirm your PIN',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This PIN unlocks your wallet on this device.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 40),
                      PinDotsIndicator(length: _pinLength, filledCount: _enteredPin.length),
                      const Spacer(),
                      NumericKeypad(onDigitTap: _onDigitTap, onBackspace: _onBackspace),
                      const SizedBox(height: 12),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _BiometricStep extends StatelessWidget {
  final bool enableBiometric;
  final ValueChanged<bool> onChanged;
  final VoidCallback onContinue;

  const _BiometricStep({
    required this.enableBiometric,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.fingerprint_rounded, color: AppColors.primary, size: 48),
          ),
        ),
        const SizedBox(height: 24),
        Text('Enable Biometric Unlock', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Use your fingerprint or face to unlock your wallet instead of typing your PIN.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const Spacer(),
        SwitchListTile(
          value: enableBiometric,
          onChanged: onChanged,
          title: const Text('Enable biometric unlock'),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onContinue,
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
