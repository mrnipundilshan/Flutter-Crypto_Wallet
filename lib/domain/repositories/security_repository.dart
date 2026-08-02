import '../entities/wallet.dart';

abstract class SecurityRepository {
  /// Persists [wallet] in encrypted secure storage, assigns it a display
  /// name if it doesn't have one, marks it active, and returns the
  /// persisted wallet.
  Future<Wallet> saveWallet(Wallet wallet);

  /// All wallets saved on this device.
  Future<List<Wallet>> getWallets();

  /// Permanently removes the wallet with [walletId] from secure storage.
  /// If it was the active wallet, another remaining wallet becomes active.
  Future<void> deleteWallet(String walletId);

  /// The wallet currently selected for use in the dashboard.
  Future<Wallet?> getActiveWallet();

  /// Switches the active wallet to [walletId]. The PIN stays valid for
  /// every wallet, so no re-authentication is required.
  Future<void> setActiveWallet(String walletId);

  /// Hashes and stores [pin] so it can later be verified.
  Future<void> setPin(String pin);

  /// Checks [pin] against the stored hash.
  Future<bool> verifyPin(String pin);

  /// Whether a PIN has already been set up on this device.
  Future<bool> hasPin();

  /// Whether the device has biometric hardware enrolled and ready to use.
  Future<bool> isBiometricAvailable();

  /// Whether the user has opted in to biometric unlock.
  Future<bool> isBiometricEnabled();

  /// Prompts the OS biometric UI. On success, persists the opt-in flag.
  Future<bool> enableBiometric();

  /// Prompts the OS biometric UI to unlock the wallet. Does not change
  /// the opt-in flag.
  Future<bool> unlockWithBiometric();
}
