import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'data/datasources/asset_local_data_source.dart';
import 'data/datasources/secure_storage_data_source.dart';
import 'data/datasources/transaction_local_data_source.dart';
import 'data/datasources/wallet_local_data_source.dart';
import 'data/repositories/asset_repository_impl.dart';
import 'data/repositories/security_repository_impl.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'data/repositories/wallet_repository_impl.dart';
import 'domain/repositories/asset_repository.dart';
import 'domain/repositories/security_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/repositories/wallet_repository.dart';
import 'domain/usecases/check_biometric_availability.dart';
import 'domain/usecases/clear_pin.dart';
import 'domain/usecases/create_wallet.dart';
import 'domain/usecases/delete_wallet.dart';
import 'domain/usecases/enable_biometric.dart';
import 'domain/usecases/estimate_gas_fee.dart';
import 'domain/usecases/get_active_wallet.dart';
import 'domain/usecases/get_assets.dart';
import 'domain/usecases/get_wallets.dart';
import 'domain/usecases/has_pin.dart';
import 'domain/usecases/import_wallet.dart';
import 'domain/usecases/is_biometric_enabled.dart';
import 'domain/usecases/save_wallet.dart';
import 'domain/usecases/send_asset.dart';
import 'domain/usecases/set_pin.dart';
import 'domain/usecases/switch_wallet.dart';
import 'domain/usecases/unlock_with_biometric.dart';
import 'domain/usecases/validate_recipient_address.dart';
import 'domain/usecases/verify_pin.dart';
import 'presentation/bloc/app_root/app_root_bloc.dart';
import 'presentation/bloc/create_wallet/create_wallet_bloc.dart';
import 'presentation/bloc/import_wallet/import_wallet_bloc.dart';
import 'presentation/bloc/set_pin/set_pin_bloc.dart';
import 'presentation/bloc/unlock/unlock_bloc.dart';
import 'presentation/bloc/wallet_dashboard/wallet_dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => AppRootBloc(hasPinUseCase: sl()));
  sl.registerFactory(() => CreateWalletBloc(createWalletUseCase: sl()));
  sl.registerFactory(() => ImportWalletBloc(importWalletUseCase: sl()));
  sl.registerFactory(() => SetPinBloc(
        checkBiometricAvailabilityUseCase: sl(),
        saveWalletUseCase: sl(),
        setPinUseCase: sl(),
        enableBiometricUseCase: sl(),
      ));
  sl.registerFactory(() => WalletDashboardBloc(
        getAssetsUseCase: sl(),
        getWalletsUseCase: sl(),
        getActiveWalletUseCase: sl(),
        switchWalletUseCase: sl(),
        deleteWalletUseCase: sl(),
        clearPinUseCase: sl(),
      ));
  sl.registerFactory(() => UnlockBloc(
        isBiometricEnabledUseCase: sl(),
        verifyPinUseCase: sl(),
        unlockWithBiometricUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => CreateWalletUseCase(sl()));
  sl.registerLazySingleton(() => ImportWalletUseCase(sl()));
  sl.registerLazySingleton(() => SaveWalletUseCase(sl()));
  sl.registerLazySingleton(() => SetPinUseCase(sl()));
  sl.registerLazySingleton(() => VerifyPinUseCase(sl()));
  sl.registerLazySingleton(() => HasPinUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletsUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveWalletUseCase(sl()));
  sl.registerLazySingleton(() => SwitchWalletUseCase(sl()));
  sl.registerLazySingleton(() => DeleteWalletUseCase(sl()));
  sl.registerLazySingleton(() => ClearPinUseCase(sl()));
  sl.registerLazySingleton(() => CheckBiometricAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => IsBiometricEnabledUseCase(sl()));
  sl.registerLazySingleton(() => EnableBiometricUseCase(sl()));
  sl.registerLazySingleton(() => UnlockWithBiometricUseCase(sl()));
  sl.registerLazySingleton(() => GetAssetsUseCase(sl()));
  sl.registerLazySingleton(() => ValidateRecipientAddressUseCase(sl()));
  sl.registerLazySingleton(() => EstimateGasFeeUseCase(sl()));
  sl.registerLazySingleton(() => SendAssetUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<SecurityRepository>(
    () => SecurityRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WalletLocalDataSource>(
    () => WalletLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SecureStorageDataSource>(
    () => SecureStorageDataSourceImpl(
      secureStorage: sl(),
      localAuth: sl(),
    ),
  );
  sl.registerLazySingleton<AssetLocalDataSource>(
    () => AssetLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(),
  );

  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => LocalAuthentication());
}
