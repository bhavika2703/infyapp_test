// lib/di.dart
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// AUTH
import 'blocs/auth/auth_bloc.dart';
import 'blocs/video/video.bloc.dart';
import 'data/datasources/firebase_auth_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';

// VIDEO
import 'data/datasources/video_firestore_datasource.dart';
import 'data/repositories/video_repository_impl.dart';
import 'domain/repositories/video_repository.dart';

final getIt = GetIt.instance;

Future<void> initDi() async {
  // ---- CORE ----
  if (!getIt.isRegistered<FirebaseFirestore>()) {
    getIt.registerLazySingleton<FirebaseFirestore>(
          () => FirebaseFirestore.instance,
    );
  }

  // ---- AUTH ----
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
        () => FirebaseAuthDataSource(),
  );

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<FirebaseAuthDataSource>()),
  );

  getIt.registerFactory<AuthBloc>(
        () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  // ---- VIDEO ----
  getIt.registerLazySingleton<VideoFirestoreDatasource>(
        () => VideoFirestoreDatasource(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<VideoRepository>(
        () => VideoRepositoryImpl(
      datasource: getIt<VideoFirestoreDatasource>(),
    ),
  );

  getIt.registerFactory<VideoBloc>(
        () => VideoBloc(
      repository: getIt<VideoRepository>(),
    ),
  );
}
