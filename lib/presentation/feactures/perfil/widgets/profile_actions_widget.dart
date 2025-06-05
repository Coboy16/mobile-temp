import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:fe_core_vips/presentation/bloc/blocs.dart';
import '/presentation/resources/resources.dart';
import '/presentation/routes/app_router.dart';
import '/core/l10n/app_localizations.dart';
import '/presentation/widgets/widgets.dart';

class ProfileActions extends StatefulWidget {
  final String? currentUserId;
  final bool isMobile;

  const ProfileActions({
    super.key,
    required this.currentUserId,
    required this.isMobile,
  });

  @override
  State<ProfileActions> createState() => _ProfileActionsState();
}

class _ProfileActionsState extends State<ProfileActions> {
  late DeleteUserBloc _deleteUserBloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _deleteUserBloc = BlocProvider.of<DeleteUserBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  void _handleSessionExpired(String message) {
    if (!mounted) return;
    _showSnackBar(message, isError: true);
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

  void _showSuccessToast(String message) {
    final l10n = AppLocalizations.of(context)!;

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: Text(l10n.accountDeletedSuccessTitle),
      description: Text(message),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      showIcon: true,
      showProgressBar: false,
    );
  }

  Future<void> _onDeleteAccount() async {
    final l10n = AppLocalizations.of(context)!;

    if (widget.currentUserId == null) {
      _showSnackBar(l10n.userIdNotAvailableError, isError: true);
      return;
    }

    // Remover cualquier SnackBar actual
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // Mostrar modal de confirmación personalizado
    final result = await CustomConfirmationModal.showSimple(
      context: context,
      title: l10n.deleteAccountTitle,
      subtitle: l10n.deleteAccountMessage,
      confirmButtonText: l10n.deleteConfirm,
      confirmButtonColor: const Color(
        0xFFDC2626,
      ), // Rojo para acción destructiva
      width: 420,
    );

    if (result == true) {
      _deleteUserBloc.add(DeleteUserRequested(userId: widget.currentUserId!));
    }
  }

  Future<void> _handleDeleteSuccess(String message) async {
    // Esperar 1 segundo antes de mostrar el toast
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Mostrar toast de éxito
    _showSuccessToast(message);

    // Logout y navegación
    _authBloc.add(AuthLogoutRequested());
    context.pushReplacementNamed(AppRoutes.auth);

    debugPrint("CUENTA ELIMINADA: Usuario deslogueado y redirigido al login");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteUserBloc, DeleteUserState>(
      bloc: _deleteUserBloc,
      listener: (context, state) {
        if (state is DeleteUserSuccess) {
          _handleDeleteSuccess(state.message);
        } else if (state is DeleteUserFailure) {
          _showSnackBar(
            'Error al eliminar cuenta: ${state.message}',
            isError: true,
          );
        } else if (state is DeleteUserSessionExpired) {
          _handleSessionExpired(state.message);
        }
      },
      child: BlocBuilder<DeleteUserBloc, DeleteUserState>(
        bloc: _deleteUserBloc,
        builder: (context, state) {
          final isLoading = state is DeleteUserLoading;

          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon:
                  isLoading
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onPrimary,
                          ),
                        ),
                      )
                      : const Icon(LucideIcons.x, size: 18),
              label: Text(isLoading ? 'Eliminando...' : 'Eliminar Cuenta'),
              onPressed: isLoading ? null : _onDeleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isLoading
                        ? AppColors.deleteButtonText.withOpacity(0.6)
                        : AppColors.deleteButtonText,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: AppTextStyles.button.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
