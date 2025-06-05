enum RequestType {
  vacation(
    'Solicitud de Vacaciones',
    'Complete los detalles de su solicitud de vacaciones',
  ),
  permission(
    'Solicitud de Permiso',
    'Complete los detalles de su solicitud de permiso',
  ),
  medicalLeave(
    'Solicitud de Licencia Médica',
    'Complete los detalles de su solicitud de licencia médica',
  ),
  suspension(
    'Solicitud de Suspensión',
    'Complete los detalles de su solicitud de suspensión',
  ),
  letter('Solicitud de Cartas', 'Complete los detalles de su solicitud'),
  accommodationChange(
    'Solicitud de Cambio de Alojamiento',
    'Complete los detalles de su solicitud',
  ),
  exitRequest('Solicitud de Salida', 'Complete los detalles de su solicitud');

  const RequestType(this.title, this.subtitle);

  final String title;
  final String subtitle;

  bool get requiresMedicalInfo => this == RequestType.medicalLeave;
}
