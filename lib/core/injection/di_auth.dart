import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '/presentation/bloc/blocs.dart';
import '/domain/domain.dart';
import '/core/core.dart';
import '/data/data.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // --- External ---

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

  // Chopper Service
  // AuthChopperService.create() ya instancia el ChopperClient con la baseUrl de AppConfig
  sl.registerLazySingleton(() => AuthChopperService.create());

  // --- Core ---
  // NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // --- Feature: Auth ---

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(chopperService: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => ValidateUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUserUseCase(sl()));

  // Google Auth Use Cases
  sl.registerLazySingleton(() => LoginWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => LogoutFromGoogleUseCase(sl()));

  // validate user
  sl.registerLazySingleton(() => CheckUserLockStatusUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      validateUserUseCase: sl(),
      loginUserUseCase: sl(),
      getCurrentUserUseCase: sl(),
      logoutUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => AuthGoogleBloc(
      loginWithGoogleUseCase: sl(),
      logoutFromGoogleUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => CheckLockStatusBloc(
      checkUserLockStatusUseCase: sl<CheckUserLockStatusUseCase>(),
    ),
  );

  // --- Feature: Register ---
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(chopperService: sl()),
  );

  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(
      registerRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));

  sl.registerLazySingleton(() => RegisterWithGoogleUseCase(sl()));

  sl.registerFactory(
    () => RegisterBloc(
      registerUserUseCase: sl<RegisterUserUseCase>(),
      registerWithGoogleUseCase: sl<RegisterWithGoogleUseCase>(),
    ),
  );

  // --- Feature: OTP ---
  // DataSource
  sl.registerLazySingleton<OtpRemoteDataSource>(
    () => OtpRemoteDataSourceImpl(chopperService: sl()),
  );
  // Repository
  sl.registerLazySingleton<OtpRepository>(
    () => OtpRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => RequestOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));

  sl.registerFactory(
    () => OtpVerificationBloc(
      requestOtpUseCase: sl<RequestOtpUseCase>(),
      verifyOtpUseCase: sl<VerifyOtpUseCase>(),
    ),
  );

  sl.registerFactory(
    () => ForgotPasswordBloc(
      requestOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      changePasswordUseCase: sl(),
    ),
  );

  // --- Feature: Google Utilities ---
  sl.registerFactory(
    () => GoogleIdTokenBloc(requestOtpUseCase: sl<RequestOtpUseCase>()),
  );
}
