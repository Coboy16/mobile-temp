import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/single_child_widget.dart';

import '/presentation/bloc/blocs.dart';
import '/domain/domain.dart';
import '/core/core.dart';

List<SingleChildWidget> getListBloc() {
  return [
    BlocProvider(create: (context) => LocaleBloc()),
    BlocProvider(
      create:
          (context) => AuthBloc(
            validateUserUseCase: sl<ValidateUserUseCase>(),
            loginUserUseCase: sl<LoginUserUseCase>(),
            getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
            logoutUserUseCase: sl<LogoutUserUseCase>(),
          ),
    ),
    BlocProvider(
      create:
          (context) => AuthGoogleBloc(
            loginWithGoogleUseCase: sl<LoginWithGoogleUseCase>(),
            logoutFromGoogleUseCase: sl<LogoutFromGoogleUseCase>(),
            getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
          ),
    ),
    BlocProvider(
      create:
          (context) => CheckLockStatusBloc(
            checkUserLockStatusUseCase: sl<CheckUserLockStatusUseCase>(),
          ),
    ),
    BlocProvider(create: (context) => sl<RegisterBloc>()),
    BlocProvider(create: (context) => sl<GoogleIdTokenBloc>()),
    BlocProvider(create: (context) => sl<OtpVerificationBloc>()),
    BlocProvider(create: (context) => sl<ForgotPasswordBloc>()),
    BlocProvider(create: (context) => sl<LocalUserDataBloc>()),
    BlocProvider(create: (context) => FcmBloc()),
    BlocProvider(create: (context) => SidebarBloc()),
    BlocProvider(create: (context) => sl<UserDetailsBloc>()),
    BlocProvider(create: (context) => NavegationBarBloc()),
  ];
}
