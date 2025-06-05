enum LetterType {
  workCertificate('Carta de trabajo'),
  incomeCertificate('Carta de ingresos'),
  recommendationLetter('Carta de recomendación'),
  bankLetter('Carta de banco'),
  visaLetter('Carta para visa');

  const LetterType(this.displayName);
  final String displayName;
}
