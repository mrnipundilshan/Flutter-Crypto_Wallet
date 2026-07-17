import 'package:get_it/get_it.dart';
import 'data/datasources/wallet_local_data_source.dart';
import 'data/repositories/wallet_repository_impl.dart';
import 'domain/repositories/wallet_repository.dart';
import 'domain/usecases/create_wallet.dart';
import 'presentation/bloc/create_wallet/create_wallet_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => CreateWalletBloc(createWalletUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => CreateWalletUseCase(sl()));

  // Repository
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WalletLocalDataSource>(
    () => WalletLocalDataSourceImpl(),
  );
}
