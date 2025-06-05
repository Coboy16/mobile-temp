enum SimpleRequestType {
  scheduleChange(
    'Solicitud de Cambio de Horario',
    'Complete los detalles de su solicitud',
  ),
  positionChange(
    'Solicitud de Cambio de Posición',
    'Complete los detalles de su solicitud',
  ),
  tipChange(
    'Solicitud de Cambio de Propina',
    'Complete los detalles de su solicitud',
  ),
  advance('Solicitud de Avance', 'Complete los detalles de su solicitud'),
  uniform('Solicitud de Uniforme', 'Complete los detalles de su solicitud'),
  letter('Solicitud de Cartas', 'Complete los detalles de su solicitud'),
  housingChange(
    'Solicitud de Cambio de Alojamiento',
    'Complete los detalles de su solicitud',
  ),
  exit('Solicitud de Salida', 'Complete los detalles de su solicitud');

  const SimpleRequestType(this.title, this.subtitle);

  final String title;
  final String subtitle;

  String get effectiveDateLabel {
    switch (this) {
      case SimpleRequestType.scheduleChange:
        return 'Fecha de efectividad';
      case SimpleRequestType.positionChange:
        return 'Fecha de efectividad';
      case SimpleRequestType.tipChange:
        return 'Fecha de efectividad';
      case SimpleRequestType.advance:
        return 'Fecha requerida';
      case SimpleRequestType.uniform:
        return 'Fecha requerida';
      case SimpleRequestType.letter:
        return 'Fecha de efectividad';
      case SimpleRequestType.housingChange:
        return '';
      case SimpleRequestType.exit:
        return 'Fecha de salida';
    }
  }

  String get reasonPlaceholder {
    switch (this) {
      case SimpleRequestType.scheduleChange:
        return 'Describa el motivo de su solicitud de cambio de horario';
      case SimpleRequestType.positionChange:
        return 'Describa el motivo de su solicitud de cambio de posición';
      case SimpleRequestType.tipChange:
        return 'Describa el motivo de su solicitud de cambio de propina';
      case SimpleRequestType.advance:
        return 'Describa el motivo de su solicitud de avance';
      case SimpleRequestType.uniform:
        return 'Describa el motivo de su solicitud de uniforme';
      case SimpleRequestType.letter:
        return 'Describa el motivo o detalles adicionales para su solicitud de carta';
      case SimpleRequestType.housingChange:
        return 'Describa el motivo de su solicitud de cambio de alojamiento';
      case SimpleRequestType.exit:
        return 'Describa el motivo de su solicitud de salida';
    }
  }

  String get importantInfo {
    switch (this) {
      case SimpleRequestType.scheduleChange:
        return 'Los cambios de horario están sujetos a la disponibilidad y necesidades operativas de la empresa. Se recomienda coordinar previamente con su supervisor.';
      case SimpleRequestType.positionChange:
        return 'Los cambios de posición están sujetos a disponibilidad y evaluación de competencias. Se requiere aprobación del área de recursos humanos.';
      case SimpleRequestType.tipChange:
        return 'Los cambios en la distribución de propinas deben cumplir con las políticas internas de la empresa y estar justificados apropiadamente.';
      case SimpleRequestType.advance:
        return 'Los avances están sujetos a políticas de la empresa y disponibilidad presupuestaria. El monto será descontado de futuros pagos.';
      case SimpleRequestType.uniform:
        return 'Las solicitudes de uniforme están sujetas a disponibilidad de inventario y políticas de reposición de la empresa.';
      case SimpleRequestType.letter:
        return 'Especifique claramente el tipo de carta que necesita y el propósito para el cual será utilizada. Adjunte cualquier documento de respaldo si es necesario.';
      case SimpleRequestType.housingChange:
        return 'Las solicitudes de cambio de alojamiento serán evaluadas según disponibilidad y políticas de la empresa. Detalle claramente su situación actual y la razón del cambio.';
      case SimpleRequestType.exit:
        return 'Las solicitudes de salida o terminación de contrato deben incluir la fecha efectiva y el motivo detallado. Asegúrese de cumplir con los plazos de preaviso establecidos en su contrato.';
    }
  }
}
