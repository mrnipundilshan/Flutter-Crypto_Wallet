import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../injection_container.dart';
import 'bloc/unlock/unlock_bloc.dart';
import 'bloc/unlock/unlock_event.dart';
import 'bloc/unlock/unlock_state.dart';
import 'wallet_dashboard.dart';
import 'widgets/numeric_keypad.dart';
import 'widgets/pin_dots_indicator.dart';
import '../core/theme/app_colors.dart';

const _pinLength = 6;

class EnterPinScreen extends StatelessWidget {
  const EnterPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UnlockBloc>(
      create: (_) => sl<UnlockBloc>()..add(UnlockStarted()),
      child: const _EnterPinView(),
    );
  }
}

class _EnterPinView extends StatefulWidget {
  const _EnterPinView();

  @override
  State<_EnterPinView> createState() => _EnterPinViewState();
}

class _EnterPinViewState extends State<_EnterPinView> {
  String _enteredPin = '';

  void _onDigitTap(String digit) {
    if (_enteredPin.length >= _pinLength) return;

    setState(() => _enteredPin += digit);
    if (_enteredPin.length == _pinLength) {
      context.read<UnlockBloc>().add(UnlockPinSubmitted(_enteredPin));
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty) return;
    setState(() => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<UnlockBloc, UnlockState>(
      listener: (context, state) {
        if (state.status == UnlockStatus.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WalletDashboard()),
            (route) => false,
          );
        } else if (state.status == UnlockStatus.failure) {
          setState(() => _enteredPin = '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Incorrect PIN.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
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
                Text('Enter your PIN', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Unlock CryptoVault to access your wallets.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                PinDotsIndicator(length: _pinLength, filledCount: _enteredPin.length),
                const Spacer(),
                NumericKeypad(onDigitTap: _onDigitTap, onBackspace: _onBackspace),
                const SizedBox(height: 12),
                BlocBuilder<UnlockBloc, UnlockState>(
                  builder: (context, state) {
                    if (!state.biometricEnabled) return const SizedBox(height: 12);
                    return Center(
                      child: TextButton.icon(
                        onPressed: () => context.read<UnlockBloc>().add(UnlockBiometricRequested()),
                        icon: const Icon(Icons.fingerprint_rounded),
                        label: const Text('Use biometric unlock'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
