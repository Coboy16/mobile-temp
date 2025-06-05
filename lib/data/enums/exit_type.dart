enum ExitType {
  resignation('Renuncia'),
  eviction('Desahucio'),
  contractTermination('Terminación de contrato'),
  dismissal('Despido');

  const ExitType(this.displayName);
  final String displayName;
}
