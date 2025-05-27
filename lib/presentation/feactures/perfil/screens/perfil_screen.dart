import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fe_core_vips/presentation/widgets/widgets.dart';
import '/presentation/feactures/perfil/widgets/widgets.dart';
import 'package:fe_core_vips/presentation/bloc/blocs.dart';
import 'package:fe_core_vips/domain/domain.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/resources/resources.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  UserDetailsEntity? _currentUserDetails;
  final _securityFormKey = GlobalKey<FormBuilderState>();
  String? _currentUserId;

  late LocalUserDataBloc _localUserDataBloc;
  late UserDetailsBloc _userDetailsBloc;
  late UpdateUserBloc _updateUserBloc;
  late ForgotPasswordBloc _forgotPasswordBloc;
  late AuthBloc _authBloc;

  bool _isLoadingInitialData = true;
  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();
    _localUserDataBloc = BlocProvider.of<LocalUserDataBloc>(context);
    _userDetailsBloc = BlocProvider.of<UserDetailsBloc>(context);
    _updateUserBloc = BlocProvider.of<UpdateUserBloc>(context);
    _forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);

    _localUserDataBloc.add(const LoadLocalUserData());
  }

  void _handleSessionExpired(String message) {
    if (!mounted) return;
    debugPrint("__________________________");
    debugPrint("Session expired: $message");
    debugPrint("__________________________");
    _showSnackBar('Session expired', isError: true);
    _authBloc.add(AuthLogoutRequested());
    context.pushReplacementNamed(AppRoutes.auth);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyText2.copyWith(
            color: isError ? AppColors.onError : AppColors.onPrimary,
          ),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.primaryVariant,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _onUpdateField(String fieldName, String newValue) {
    if (_currentUserId == null || _currentUserDetails == null) {
      _showSnackBar(
        'Datos del perfil no cargados. No se puede actualizar.',
        isError: true,
      );
      return;
    }

    String updatedName = _currentUserDetails!.name;
    String updatedFatherLastname = _currentUserDetails!.fatherLastname ?? '';
    String updatedMotherLastname = _currentUserDetails!.motherLastname ?? '';

    if (fieldName == 'name') {
      updatedName = newValue;
    } else if (fieldName == 'fatherLastname') {
      updatedFatherLastname = newValue;
    } else if (fieldName == 'motherLastname') {
      updatedMotherLastname = newValue;
    } else {
      debugPrint(
        "Campo '$fieldName' no es parte de la actualización del backend en este flujo.",
      );
      return;
    }

    _updateUserBloc.add(
      UpdateUserDataRequested(
        userId: _currentUserId!,
        name: updatedName,
        fatherLastname: updatedFatherLastname,
        motherLastname: updatedMotherLastname,
      ),
    );
  }

  void _onSaveChangesPassword() {
    if (_isChangingPassword) return;

    if (_securityFormKey.currentState?.saveAndValidate() ?? false) {
      final newPassword =
          _securityFormKey.currentState!.value['contrasenaNueva'] as String?;

      if (_currentUserDetails == null || _currentUserDetails!.email.isEmpty) {
        _showSnackBar(
          'No se pudo obtener el email del usuario. Intenta recargar la página.',
          isError: true,
        );
        return;
      }

      if (newPassword != null && newPassword.isNotEmpty) {
        _forgotPasswordBloc.add(
          ForgotPasswordNewPasswordSubmitted(
            email: _currentUserDetails!.email,
            newPassword: newPassword,
          ),
        );
      } else {
        _showSnackBar('No se especificó una nueva contraseña.', isError: true);
      }
    } else {
      _showSnackBar(
        'Por favor, corrige los errores en la sección de seguridad.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final useTwoColumnLayout = ResponsiveBreakpoints.of(
      context,
    ).largerThan(MOBILE);

    return MultiBlocListener(
      listeners: [
        BlocListener<LocalUserDataBloc, LocalUserDataState>(
          bloc: _localUserDataBloc,
          listener: (context, state) {
            if (state is LocalUserDataLoaded) {
              print(
                'PERFIL SCREEN - LocalUserDataLoaded: User ID: ${state.user.id}, Token: ${state.token}',
              ); // LOG ESTO
              print(
                'PERFIL SCREEN - LocalUserDataLoaded: User Type: ${state.user.runtimeType}',
              ); // ¿Es UserEntity?
              if (_currentUserId != state.user.id ||
                  _userDetailsBloc.state is UserDetailsInitial) {
                _currentUserId = state.user.id;
                _userDetailsBloc.add(
                  FetchUserDetailsById(userId: state.user.id),
                );
              }
            } else if (state is NoLocalUserData) {
              if (mounted) setState(() => _isLoadingInitialData = false);
              _showSnackBar(
                'No se encontraron datos de usuario local. Por favor, inicia sesión.',
                isError: true,
              );
              _userDetailsBloc.add(const ResetUserDetails());
            } else if (state is LocalUserDataFailure) {
              if (mounted) setState(() => _isLoadingInitialData = false);
              _showSnackBar(
                'Error al cargar datos locales: ${state.message}',
                isError: true,
              );
              _userDetailsBloc.add(const ResetUserDetails());
            } else if (state is LocalUserDataLoading) {
              if (mounted) setState(() => _isLoadingInitialData = true);
            }
          },
        ),
        BlocListener<UserDetailsBloc, UserDetailsState>(
          bloc: _userDetailsBloc,
          listener: (context, state) {
            if (state is UserDetailsLoaded) {
              if (mounted) {
                setState(() {
                  _currentUserDetails = state.userDetails;
                  _currentUserId = state.userDetails.userId;
                  _isLoadingInitialData = false;
                });
              }
              _updateUserBloc.add(const ResetUpdateUserState());
            } else if (state is UserDetailsFailure) {
              if (mounted) setState(() => _isLoadingInitialData = false);
              _handleSessionExpired(state.message);
            } else if (state is UserDetailsSessionExpired) {
              if (mounted) setState(() => _isLoadingInitialData = false);
              _handleSessionExpired(state.message);
            } else if (state is UserDetailsLoading) {
              if (_currentUserDetails == null && mounted) {
                setState(() => _isLoadingInitialData = true);
              }
            } else if (state is UserDetailsInitial) {
              if (_localUserDataBloc.state is! LocalUserDataLoading &&
                  mounted) {
                setState(() {
                  _currentUserDetails = null;
                  _isLoadingInitialData = false;
                });
              }
            }
          },
        ),
        BlocListener<UpdateUserBloc, UpdateUserState>(
          bloc: _updateUserBloc,
          listener: (context, state) {
            if (state is UpdateUserSuccess) {
              _showSnackBar(state.message);
              if (_currentUserId != null) {
                _userDetailsBloc.add(
                  FetchUserDetailsById(userId: _currentUserId!),
                );
              }
            } else if (state is UpdateUserFailure) {
              _showSnackBar(
                'Error del servidor al actualizar: ${state.message}',
                isError: true,
              );
            } else if (state is UpdateUserSessionExpired) {
              _handleSessionExpired(state.message);
            }
          },
        ),
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          bloc: _forgotPasswordBloc,
          listener: (context, state) {
            if (state is ForgotPasswordChangeInProgress) {
              if (mounted) setState(() => _isChangingPassword = true);
            } else if (state is ForgotPasswordChangeSuccess) {
              if (mounted) setState(() => _isChangingPassword = false);
              _showSnackBar('Contraseña actualizada con éxito.');
              _securityFormKey.currentState?.reset();
              _forgotPasswordBloc.add(ForgotPasswordReset());
            } else if (state is ForgotPasswordChangeFailure) {
              if (mounted) setState(() => _isChangingPassword = false);
              _showSnackBar(
                'Error al cambiar contraseña: ${state.message}',
                isError: true,
              );
              _forgotPasswordBloc.add(ForgotPasswordReset());
            } else if (state is ForgotPasswordInitial) {
              if (mounted && _isChangingPassword) {
                setState(() => _isChangingPassword = false);
              }
            }
          },
        ),
      ],
      child: Stack(
        children: [
          if (!_isLoadingInitialData && _currentUserDetails != null)
            Center(
              child: MaxWidthBox(
                maxWidth: useTwoColumnLayout ? 1100 : 700,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        isMobile ? 16.0 : (useTwoColumnLayout ? 32.0 : 24.0),
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (useTwoColumnLayout)
                        _buildWebContent(isMobile)
                      else
                        _buildMobileContent(isMobile),
                    ],
                  ),
                ),
              ),
            ),
          if (_isLoadingInitialData)
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: const CustomLoadingHotech(
                overlay: false,
                message: "Cargando datos del perfil...",
              ),
            ),
          BlocBuilder<UpdateUserBloc, UpdateUserState>(
            bloc: _updateUserBloc,
            builder: (context, state) {
              if (state is UpdateUserLoading) {
                return Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: const CustomLoadingHotech(
                    overlay: false,
                    message: "Actualizando datos...",
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<UserDetailsBloc, UserDetailsState>(
            bloc: _userDetailsBloc,
            builder: (context, state) {
              if (state is UserDetailsLoading &&
                  !_isLoadingInitialData &&
                  _currentUserDetails == null) {
                return const CustomLoadingHotech(
                  overlay: true,
                  message: "Cargando perfil...",
                );
              }
              return const SizedBox.shrink();
            },
          ),
          if (_isChangingPassword &&
              _updateUserBloc.state is! UpdateUserLoading &&
              !(_userDetailsBloc.state is UserDetailsLoading &&
                  _currentUserDetails == null) &&
              !_isLoadingInitialData)
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: const CustomLoadingHotech(
                overlay: false,
                message: "Actualizando contraseña...",
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileDetailsList(
          userDataFromEntity: _currentUserDetails,
          onUpdateField: _onUpdateField,
        ),
        const SizedBox(height: 24.0),
        SecuritySettingsCard(
          formKey: _securityFormKey,
          email: _currentUserDetails?.email ?? 'cargando...',
          onSaveChangesPassword: _onSaveChangesPassword,
          isChangingPassword: _isChangingPassword,
        ),
      ],
    );
  }

  Widget _buildWebContent(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: ProfileDetailsList(
            userDataFromEntity: _currentUserDetails,
            onUpdateField: _onUpdateField,
          ),
        ),
        const SizedBox(width: 32.0),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SecuritySettingsCard(
                formKey: _securityFormKey,
                email: _currentUserDetails?.email ?? 'cargando...',
                onSaveChangesPassword: _onSaveChangesPassword,
                isChangingPassword: _isChangingPassword,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
