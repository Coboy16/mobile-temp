import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/presentation/feactures/request/temp/request_options.dart';
import '/presentation/feactures/request/helpers/helpers.dart';
import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/resources/colors.dart';
import '/presentation/bloc/blocs.dart';

class SelectRequestTypeDialog extends StatelessWidget {
  const SelectRequestTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isTabletOrDesktop = ResponsiveBreakpoints.of(
      context,
    ).largerThan(MOBILE);

    return MultiBlocListener(
      listeners: [
        // Listener para Vacaciones
        BlocListener<VacationRequestBloc, VacationRequestState>(
          listener: (context, state) {
            if (state is VacationRequestSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            } else if (state is VacationRequestFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        ),
        // Listener para Permisos
        BlocListener<PermissionRequestBloc, PermissionRequestState>(
          listener: (context, state) {
            if (state is PermissionRequestSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            } else if (state is PermissionRequestFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        ),
        // Listener para Licencia Médica
        BlocListener<MedicalLeaveRequestBloc, MedicalLeaveRequestState>(
          listener: (context, state) {
            if (state is MedicalLeaveRequestSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            } else if (state is MedicalLeaveRequestFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        ),
        // Listener para Suspensión
        BlocListener<SuspensionRequestBloc, SuspensionRequestState>(
          listener: (context, state) {
            if (state is SuspensionRequestSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            } else if (state is SuspensionRequestFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        ),
      ],
      child: Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        insetPadding: EdgeInsets.all(isTabletOrDesktop ? 24.0 : 16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTabletOrDesktop ? 1000 : double.infinity,
            maxHeight:
                isTabletOrDesktop
                    ? 520
                    : MediaQuery.of(context).size.height * 0.85,
          ),
          child: Padding(
            padding: EdgeInsets.all(isTabletOrDesktop ? 32.0 : 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con título y botón cerrar
                _buildHeader(context, isTabletOrDesktop),
                SizedBox(height: isTabletOrDesktop ? 32 : 24),

                // Contenido responsive
                Expanded(
                  child:
                      isTabletOrDesktop
                          ? _buildGridView(context)
                          : _buildListView(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTabletOrDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                'Selecciona el tipo de solicitud',
                style: TextStyle(
                  fontSize: isTabletOrDesktop ? 20 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                minFontSize: 16,
              ),
              const SizedBox(height: 6),
              AutoSizeText(
                'Elige el tipo de solicitud que deseas crear',
                style: TextStyle(
                  fontSize: isTabletOrDesktop ? 14 : 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                minFontSize: 11,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: Icon(
            Icons.close,
            size: isTabletOrDesktop ? 20 : 22,
            color: Colors.grey.shade600,
          ),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 16,
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  // Vista en Grid para tablet/desktop
  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 2.0,
      ),
      itemCount: requestOptions.length,
      itemBuilder: (context, index) {
        return _buildGridOptionCard(context, requestOptions[index]);
      },
    );
  }

  // Vista en Lista para móvil
  Widget _buildListView(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: requestOptions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _buildListOptionCard(context, requestOptions[index]);
      },
    );
  }

  // Card para vista en Grid (tablet/desktop)
  Widget _buildGridOptionCard(BuildContext context, RequestTypeOption option) {
    return InkWell(
      onTap: () => _handleRequestTypeSelection(context, option.typeId),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono y título
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  maxRadius: 16,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      option.icon,
                      size: 18,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AutoSizeText(
                    option.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey.shade900,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Descripción
            AutoSizeText(
              option.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.3,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Card para vista en Lista (móvil)
  Widget _buildListOptionCard(BuildContext context, RequestTypeOption option) {
    return InkWell(
      onTap: () => _handleRequestTypeSelection(context, option.typeId),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.15),
              radius: 22,
              child: Icon(option.icon, size: 22, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 16),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    option.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey.shade900,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                  ),
                  const SizedBox(height: 4),
                  AutoSizeText(
                    option.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.3,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    minFontSize: 11,
                  ),
                ],
              ),
            ),
            // Flecha indicadora
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  /// Maneja la selección del tipo de solicitud
  void _handleRequestTypeSelection(BuildContext context, String typeId) {
    Navigator.of(context).pop();

    switch (typeId) {
      case 'vacation':
        _openVacationRequest(context);
        break;
      case 'permit':
        _openPermitRequest(context);
        break;
      case 'medical':
        _openMedicalLeaveRequest(context);
        break;
      case 'suspension':
        _openSuspensionRequest(context);
        break;
      case 'schedule_change':
        _openScheduleChangeRequest(context);
        break;
      case 'position_change':
        _openPositionChangeRequest(context);
        break;
      case 'tip_change':
        _openTipChangeRequest(context);
        break;
      case 'advance':
        _openAdvanceRequest(context);
        break;
      case 'letter':
        _openLetterRequest(context);
        break;
      case 'uniform':
        _openUniformRequest(context);
        break;
      case 'housing_change':
        _openHousingChangeRequest(context);
        break;
      case 'exit':
        _openExitRequest(context);
        break;
      default:
        _showNotImplementedDialog(context, typeId);
    }
  }

  // ========== MÉTODOS COMPLETAMENTE CORREGIDOS ==========

  /// Abrir solicitud de vacaciones con BLoC - SOLUCIÓN COMPLETA
  void _openVacationRequest(BuildContext context) async {
    // Guardar TODAS las referencias necesarias ANTES de abrir el modal
    final vacationBloc = context.read<VacationRequestBloc>();
    final navigator = Navigator.of(context);

    final result = await RequestModalHelper.showVacationRequestModal(
      context,
      onSubmit: (requestData) {
        debugPrint('✅ Procesando solicitud de vacaciones');

        // Usar SOLO las referencias guardadas, NO el context del callback
        navigator.pop(requestData.toMap());

        // Enviar evento al BLoC usando la referencia guardada
        vacationBloc.add(SubmitVacationRequest(requestData));

        debugPrint('✅ Evento de vacaciones enviado al BLoC');
      },
    );

    if (result != null) {
      debugPrint('✅ Resultado de solicitud de vacaciones: $result');
    }
  }

  /// Abrir solicitud de permiso con BLoC - SOLUCIÓN COMPLETA
  void _openPermitRequest(BuildContext context) async {
    // Guardar TODAS las referencias necesarias ANTES de abrir el modal
    final permissionBloc = context.read<PermissionRequestBloc>();
    final navigator = Navigator.of(context);

    final result = await RequestModalHelper.showPermissionRequestModal(
      context,
      onSubmit: (requestData) {
        debugPrint('✅ Procesando solicitud de permiso');

        // Usar SOLO las referencias guardadas, NO el context del callback
        navigator.pop(requestData.toMap());

        // Enviar evento al BLoC usando la referencia guardada
        permissionBloc.add(SubmitPermissionRequest(requestData));

        debugPrint('✅ Evento de permiso enviado al BLoC');
      },
    );

    if (result != null) {
      debugPrint('✅ Resultado de solicitud de permiso: $result');
    }
  }

  /// Abrir solicitud de licencia médica con BLoC - SOLUCIÓN COMPLETA
  void _openMedicalLeaveRequest(BuildContext context) async {
    // Guardar TODAS las referencias necesarias ANTES de abrir el modal
    final medicalLeaveBloc = context.read<MedicalLeaveRequestBloc>();
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final result = await RequestModalHelper.showMedicalLeaveRequestModal(
      context,
      onSubmit: (requestData) {
        debugPrint('✅ Procesando solicitud de licencia médica');

        // Validaciones específicas para licencia médica
        if (requestData.medicalInfo == null ||
            requestData.medicalInfo!.isEmpty) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Error: La información médica es requerida'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        if (requestData.medicalLicenseType == null) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Error: Debe seleccionar el tipo de licencia'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Usar SOLO las referencias guardadas, NO el context del callback
        navigator.pop(requestData.toMap());

        // Enviar evento al BLoC usando la referencia guardada
        medicalLeaveBloc.add(SubmitMedicalLeaveRequest(requestData));

        debugPrint('✅ Evento de licencia médica enviado al BLoC');
      },
    );

    if (result != null) {
      debugPrint('✅ Resultado de solicitud de licencia médica: $result');
    }
  }

  /// Abrir solicitud de suspensión con BLoC - SOLUCIÓN COMPLETA
  void _openSuspensionRequest(BuildContext context) async {
    // Guardar TODAS las referencias necesarias ANTES de abrir el modal
    final suspensionBloc = context.read<SuspensionRequestBloc>();
    final navigator = Navigator.of(context);

    final result = await RequestModalHelper.showSuspensionRequestModal(
      context,
      onSubmit: (requestData) {
        debugPrint('✅ Procesando solicitud de suspensión');

        // Usar SOLO las referencias guardadas, NO el context del callback
        navigator.pop(requestData.toMap());

        // Enviar evento al BLoC usando la referencia guardada
        suspensionBloc.add(SubmitSuspensionRequest(requestData));

        debugPrint('✅ Evento de suspensión enviado al BLoC');
      },
    );

    if (result != null) {
      debugPrint('✅ Resultado de solicitud de suspensión: $result');
    }
  }

  // ========== MÉTODOS TEMPORALES PARA OTROS TIPOS ==========

  void _openScheduleChangeRequest(BuildContext context) async {
    final scheduleChangeBloc = context.read<ScheduleChangeBloc>();
    final navigator = Navigator.of(context);

    final result = await SimpleRequestHelper.showScheduleChangeModal(
      context,
      onSubmit: (requestData) {
        debugPrint('✅ Procesando solicitud de cambio de horario');

        navigator.pop(requestData.toMap());

        scheduleChangeBloc.add(SubmitScheduleChangeRequest(requestData));

        debugPrint('✅ Evento de cambio de horario enviado al BLoC');
      },
    );

    if (result != null) {
      debugPrint('✅ Resultado de solicitud de cambio de horario: $result');
    }
  }

  void _openPositionChangeRequest(BuildContext context) async {
    final positionChangeBloc = context.read<PositionChangeBloc>();
    final navigator = Navigator.of(context);

    final result = await SimpleRequestHelper.showPositionChangeModal(
      context,
      onSubmit: (requestData) {
        debugPrint('✅ Procesando solicitud de cambio de posición');

        navigator.pop(requestData.toMap());

        // Enviar evento al BLoC usando la referencia guardada
        positionChangeBloc.add(SubmitPositionChangeRequest(requestData));

        debugPrint('✅ Evento de cambio de posición enviado al BLoC');
      },
    );

    if (result != null) {
      debugPrint('✅ Resultado de solicitud de cambio de posición: $result');
    }
  }

  void _openTipChangeRequest(BuildContext context) async {
    final tipChangeBloc = context.read<TipChangeBloc>();
    final navigator = Navigator.of(context);

    final result = await SimpleRequestHelper.showTipChangeModal(
      context,
      onSubmit: (requestData) {
        debugPrint('✅ Procesando solicitud de cambio de propina');

        navigator.pop(requestData.toMap());

        // Enviar evento al BLoC usando la referencia guardada
        tipChangeBloc.add(SubmitTipChangeRequest(requestData));

        debugPrint('✅ Evento de cambio de propina enviado al BLoC');
      },
    );

    if (result != null) {
      debugPrint('✅ Resultado de solicitud de cambio de propina: $result');
    }
  }

  void _openAdvanceRequest(BuildContext context) async {
    final advanceBloc = context.read<AdvanceRequestBloc>();
    final navigator = Navigator.of(context);

    final result = await SimpleRequestHelper.showAdvanceModal(
      context,
      onSubmit: (requestData) {
        debugPrint('✅ Procesando solicitud de avance');

        navigator.pop(requestData.toMap());

        // Enviar evento al BLoC usando la referencia guardada
        advanceBloc.add(SubmitAdvanceRequest(requestData));

        debugPrint('✅ Evento de avance enviado al BLoC');
      },
    );

    if (result != null) {
      debugPrint('✅ Resultado de solicitud de avance: $result');
    }
  }

  void _openUniformRequest(BuildContext context) async {
    final uniformBloc = context.read<UniformRequestBloc>();
    final navigator = Navigator.of(context);

    final result = await SimpleRequestHelper.showUniformModal(
      context,
      onSubmit: (requestData) {
        debugPrint('✅ Procesando solicitud de uniforme');

        navigator.pop(requestData.toMap());

        // Enviar evento al BLoC usando la referencia guardada
        uniformBloc.add(SubmitUniformRequest(requestData));

        debugPrint('✅ Evento de uniforme enviado al BLoC');
      },
    );

    if (result != null) {
      debugPrint('✅ Resultado de solicitud de uniforme: $result');
    }
  }

  void _openLetterRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Solicitud de Carta');
  }

  void _openHousingChangeRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Cambio de Alojamiento');
  }

  void _openExitRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Solicitud de Salida');
  }

  void _showNotImplementedDialog(BuildContext context, String typeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tipo no implementado'),
          content: Text('El tipo de solicitud "$typeId" no está implementado.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context, String requestType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Próximamente'),
          content: Text(
            'La funcionalidad "$requestType" estará disponible pronto.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Función helper para mostrar el selector de tipos de solicitud
class RequestTypeHelper {
  static Future<void> showRequestTypeSelector(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const SelectRequestTypeDialog();
      },
    );
  }
}
