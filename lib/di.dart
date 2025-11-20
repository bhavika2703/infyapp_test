import 'package:get_it/get_it.dart';
import '../blocs/auth/auth_bloc.dart';
import '../data/datasources/firebase_auth_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> initDi() async {
  // datasources
  getIt.registerLazySingleton(() => FirebaseAuthDataSource());
  // repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<FirebaseAuthDataSource>()));
  // bloc factory
  getIt.registerFactory(() => AuthBloc(authRepository: getIt<AuthRepository>()));
}
