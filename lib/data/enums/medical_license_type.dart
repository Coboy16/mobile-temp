enum MedicalLicenseType {
  maternity('Licencia por Maternidad'),
  paternity('Licencia por Paternidad'),
  illness('Licencia por Enfermedad'),
  accident('Licencia por Accidente'),
  familyCare('Licencia por Cuidado familiar'),
  other('Otro');

  const MedicalLicenseType(this.displayName);
  final String displayName;
}
