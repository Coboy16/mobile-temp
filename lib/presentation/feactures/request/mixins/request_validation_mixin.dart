import '/data/data.dart';

mixin RequestValidationMixin {
  bool validateEmployee(
    Employee? selectedEmployee,
    Function(String?) setError,
  ) {
    if (selectedEmployee == null) {
      setError('Debe seleccionar un empleado');
      return false;
    }
    setError(null);
    return true;
  }

  bool validateMedicalLicenseType(
    MedicalLicenseType? licenseType,
    Function(String?) setError,
  ) {
    if (licenseType == null) {
      setError('Debe seleccionar el tipo de licencia');
      return false;
    }
    setError(null);
    return true;
  }

  bool validateDateAndDays(
    DateTime? startDate,
    int? numberOfDays,
    Function(String?, String?) setErrors,
  ) {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final fifteenDaysFromToday = todayMidnight.add(const Duration(days: 15));

    bool isValid = true;
    String? startDateError;
    String? numberOfDaysError;

    // Validar fecha de inicio
    if (startDate == null) {
      startDateError = '- La fecha de inicio es obligatoria';
      isValid = false;
    } else if (startDate.isBefore(fifteenDaysFromToday)) {
      startDateError =
          'La solicitud debe ser con al menos 15 días de anticipación';
      isValid = false;
    }

    // Validar cantidad de días
    if (numberOfDays == null) {
      numberOfDaysError = '- Debe seleccionar la cantidad de días';
      isValid = false;
    }

    setErrors(startDateError, numberOfDaysError);
    return isValid;
  }
}
