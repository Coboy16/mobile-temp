import 'package:fe_core_vips/presentation/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/presentation/resources/resources.dart';
import '/presentation/widgets/widgets.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  void initState() {
    super.initState();
    context.read<LocalUserDataBloc>().add(const LoadLocalUserData());
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> nameParts = name.split(' ');
    if (nameParts.isEmpty) return '';
    String initials = nameParts[0][0];
    if (nameParts.length > 1) {
      initials += nameParts[1][0];
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = AppColors.sidebarText;
    final Color subTextColor = textColor.withOpacity(0.7);

    return BlocBuilder<LocalUserDataBloc, LocalUserDataState>(
      builder: (context, state) {
        String userName = 'Usuario';
        String userInitials = 'U';
        String userRoleOrEmail = 'No disponible';

        if (state is LocalUserDataLoaded) {
          userName = state.user.name;
          userInitials = _getInitials(state.user.name);
          userRoleOrEmail = state.user.email;
        } else if (state is LocalUserDataLoading) {
          userName = 'Cargando...';
          userInitials = '';
          userRoleOrEmail = 'Cargando...';
        } else if (state is NoLocalUserData || state is LocalUserDataFailure) {
          userName = 'Invitado';
          userInitials = 'I';
          userRoleOrEmail = 'No autenticado';
        }

        return InkWell(
          onTap: () {
            debugPrint('Info Usuario Tapped. Estado: $state');
            if (state is LocalUserDataLoaded) {
              debugPrint(
                'Usuario: ${state.user.name}, Token: ${state.token.substring(0, 10)}...',
              );
            }
          },
          child: Container(
            height: userInfoHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.indigo,
                  child: Text(
                    userInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        // 'Administrador', // Si tienes un campo de rol, úsalo aquí
                        // Por ahora, mostraremos el email o un texto genérico
                        userRoleOrEmail,
                        style: TextStyle(color: subTextColor, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
