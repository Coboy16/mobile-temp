import 'package:fe_core_vips/domain/domain.dart';
import 'package:fe_core_vips/presentation/bloc/blocs.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/feactures/perfil/widgets/widgets.dart';
import '/presentation/resources/resources.dart';

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  UserDetailsEntity? _currentUserDetails;
  String? _currentUserId;

  late LocalUserDataBloc _localUserDataBloc;
  late UserDetailsBloc _userDetailsBloc;

  bool _isLoadingInitialData = true;

  @override
  void initState() {
    super.initState();
    _localUserDataBloc = BlocProvider.of<LocalUserDataBloc>(context);
    _userDetailsBloc = BlocProvider.of<UserDetailsBloc>(context);

    // Cargar datos del usuario si no están ya cargados
    _loadUserData();
  }

  void _loadUserData() {
    final localUserState = _localUserDataBloc.state;
    if (localUserState is LocalUserDataLoaded) {
      _currentUserId = localUserState.user.id;
      _userDetailsBloc.add(
        FetchUserDetailsById(userId: localUserState.user.id),
      );
    } else {
      _localUserDataBloc.add(const LoadLocalUserData());
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return MultiBlocListener(
      listeners: [
        BlocListener<LocalUserDataBloc, LocalUserDataState>(
          bloc: _localUserDataBloc,
          listener: (context, state) {
            if (state is LocalUserDataLoaded) {
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
            } else if (state is LocalUserDataFailure) {
              if (mounted) setState(() => _isLoadingInitialData = false);
              _showSnackBar(
                'Error al cargar datos locales: ${state.message}',
                isError: true,
              );
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
            } else if (state is UserDetailsFailure) {
              if (mounted) setState(() => _isLoadingInitialData = false);
              _showSnackBar(
                'Error al cargar detalles del perfil: ${state.message}',
                isError: true,
              );
            } else if (state is UserDetailsLoading) {
              if (_currentUserDetails == null && mounted) {
                setState(() => _isLoadingInitialData = true);
              }
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  children: [
                    const Icon(LucideIcons.lock, color: AppColors.primaryBlue),
                    const SizedBox(width: 10),
                    AutoSizeText(
                      'Seguridad',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: AutoSizeText(
                  'Administra la seguridad de tu cuenta',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 20),

              // Mostrar loading o contenido
              if (_isLoadingInitialData)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_currentUserId != null)
                ProfileActions(
                  currentUserId: _currentUserId,
                  isMobile: isMobile,
                )
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'No se pudieron cargar los datos del usuario',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
