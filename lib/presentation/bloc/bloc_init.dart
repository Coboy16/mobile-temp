import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/single_child_widget.dart';

import '/presentation/bloc/blocs.dart';
import '/domain/domain.dart';
import '/core/core.dart';

List<SingleChildWidget> getListBloc() {
  return [
    BlocProvider(create: (context) => LocaleBloc()),
    BlocProvider(create: (context) => ThemeBloc()),
    BlocProvider(create: (context) => sl<CheckSessionStatusBloc>()),
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
    BlocProvider(create: (context) => sl<UpdateUserBloc>()),
    BlocProvider(create: (context) => sl<DeleteUserBloc>()),
    BlocProvider(create: (context) => NavegationBarBloc()),
    BlocProvider(create: (context) => SettingsBloc()),
    BlocProvider(create: (context) => EmployeeSearchBloc()),
    BlocProvider(create: (context) => RequestFilterBloc()),
    BlocProvider<VacationRequestBloc>(create: (_) => VacationRequestBloc()),
    BlocProvider<PermissionRequestBloc>(create: (_) => PermissionRequestBloc()),
    BlocProvider<MedicalLeaveRequestBloc>(
      create: (_) => MedicalLeaveRequestBloc(),
    ),
    BlocProvider<SuspensionRequestBloc>(create: (_) => SuspensionRequestBloc()),
    BlocProvider<FileUploadBloc>(
      create:
          (_) => FileUploadBloc(
            allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
            maxFileSizeMB: 5,
            maxFiles: 1,
          ),
    ),
    BlocProvider<ScheduleChangeBloc>(create: (_) => ScheduleChangeBloc()),
    BlocProvider<PositionChangeBloc>(create: (_) => PositionChangeBloc()),
    BlocProvider<TipChangeBloc>(create: (_) => TipChangeBloc()),
    BlocProvider<AdvanceRequestBloc>(create: (_) => AdvanceRequestBloc()),
    BlocProvider<UniformRequestBloc>(create: (_) => UniformRequestBloc()),
  ];
}
