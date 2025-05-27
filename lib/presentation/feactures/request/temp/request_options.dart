import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

class RequestTypeOption {
  final IconData icon;
  final String title;
  final String description;
  final String typeId;

  const RequestTypeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.typeId,
  });
}

final List<RequestTypeOption> requestOptions = [
  const RequestTypeOption(
    icon: LucideIcons.umbrella,
    title: 'Vacaciones',
    description: 'Solicitud de días libres remunerados',
    typeId: 'vacation',
  ),
  const RequestTypeOption(
    icon: LucideIcons.calendarDays,
    title: 'Permiso',
    description: 'Solicitud para ausentarse por tiempo limitado',
    typeId: 'permit',
  ),
  const RequestTypeOption(
    icon: LucideIcons.stethoscope,
    title: 'Licencia Médica',
    description: 'Ausencia por motivos de salud',
    typeId: 'medical',
  ),
  const RequestTypeOption(
    icon: LucideIcons.clock,
    title: 'Suspensión',
    description: 'Solicitud de suspensión temporal',
    typeId: 'suspension',
  ), // Icono aproximado
  const RequestTypeOption(
    icon: LucideIcons.alarmClock,
    title: 'Cambio de Horario',
    description: 'Modificación de horario laboral',
    typeId: 'schedule_change',
  ),
  const RequestTypeOption(
    icon: LucideIcons.repeat,
    title: 'Cambio de Posición',
    description: 'Solicitud de transferencia o cambio de puesto',
    typeId: 'position_change',
  ),
  const RequestTypeOption(
    icon: LucideIcons.coins,
    title: 'Cambio de Propina',
    description: 'Ajuste en la distribución de propinas',
    typeId: 'tip_change',
  ), // Icono aproximado
  const RequestTypeOption(
    icon: LucideIcons.creditCard,
    title: 'Avances',
    description: 'Solicitud de avance o adelanto de salario',
    typeId: 'advance',
  ),
  const RequestTypeOption(
    icon: LucideIcons.mail,
    title: 'Cartas',
    description: 'Solicitud de documentos oficiales',
    typeId: 'letter',
  ),
  const RequestTypeOption(
    icon: LucideIcons.shirt,
    title: 'Uniforme',
    description: 'Solicitud de uniforme de trabajo',
    typeId: 'uniform',
  ), // Icono aproximado
  const RequestTypeOption(
    icon: LucideIcons.house,
    title: 'Cambio de Alojamiento',
    description: 'Solicitud de cambio de alojamiento',
    typeId: 'housing_change',
  ),
  const RequestTypeOption(
    icon: LucideIcons.userMinus,
    title: 'Salida',
    description: 'Solicitud de salida o terminación de contrato',
    typeId: 'exit',
  ), // Icono aproximado
];
