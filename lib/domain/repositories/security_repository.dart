import '../entities/wallet.dart';

abstract class SecurityRepository {
  /// Persists [wallet] in encrypted secure storage.
  Future<void> saveWallet(Wallet wallet);

  /// Hashes and stores [pin] so it can later be verified.
  Future<void> setPin(String pin);

  /// Whether the device has biometric hardware enrolled and ready to use.
  Future<bool> isBiometricAvailable();

  /// Prompts the OS biometric UI. On success, persists the opt-in flag.
  Future<bool> enableBiometric();
}
