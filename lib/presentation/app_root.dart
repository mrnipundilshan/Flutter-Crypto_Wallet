import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../injection_container.dart';
import 'bloc/app_root/app_root_bloc.dart';
import 'bloc/app_root/app_root_event.dart';
import 'bloc/app_root/app_root_state.dart';
import 'enter_pin_screen.dart';
import 'onboarding_screen.dart';

/// Decides whether the app opens on the PIN-unlock screen (a wallet was
/// already set up on this device) or the onboarding flow (first launch).
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppRootBloc>(
      create: (_) => sl<AppRootBloc>()..add(AppStartupRequested()),
      child: BlocBuilder<AppRootBloc, AppRootState>(
        builder: (context, state) {
          switch (state.status) {
            case AppRootStatus.needsUnlock:
              return const EnterPinScreen();
            case AppRootStatus.needsOnboarding:
              return const OnboardingScreen();
            case AppRootStatus.loading:
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}
