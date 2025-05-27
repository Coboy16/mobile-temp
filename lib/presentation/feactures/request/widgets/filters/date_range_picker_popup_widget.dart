import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePickerPopup extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? initialMonth; // Mes inicial a mostrar

  const DateRangePickerPopup({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.initialMonth,
  });

  @override
  State<DateRangePickerPopup> createState() => _DateRangePickerPopupState();
}

class _DateRangePickerPopupState extends State<DateRangePickerPopup> {
  late DateTime _displayedMonth1;
  late DateTime _displayedMonth2;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Formateador para el nombre del mes y año
  late DateFormat _monthYearFormat;

  // Nombres de los días de la semana en español (corto)
  final List<String> _dayHeaders = ['lu', 'ma', 'mi', 'ju', 'vi', 'sá', 'do'];

  @override
  void initState() {
    super.initState();
    // Asegurarse que la localización español está lista
    // Es mejor hacerlo en main(), pero como fallback rápido aquí:
    try {
      _monthYearFormat = DateFormat('MMMM yyyy', 'es_ES');
    } catch (e) {
      print("Error inicializando formato 'es_ES'. Usando formato por defecto.");
      // Considera inicializar localización en main() con initializeDateFormatting('es_ES', null)
      _monthYearFormat = DateFormat('MMMM yyyy'); // Fallback
    }

    // Establece los meses iniciales a mostrar
    DateTime initial = widget.initialMonth ?? DateTime.now();
    // Asegurarse que initial no cause error si es el día 31 y el mes siguiente no lo tiene
    initial = DateTime(initial.year, initial.month, 1);
    _displayedMonth1 = DateTime(initial.year, initial.month, 1);
    // Calcular el mes siguiente correctamente, manejando fin de año
    if (_displayedMonth1.month == 12) {
      _displayedMonth2 = DateTime(_displayedMonth1.year + 1, 1, 1);
    } else {
      _displayedMonth2 = DateTime(
        _displayedMonth1.year,
        _displayedMonth1.month + 1,
        1,
      );
    }

    // Establece las fechas seleccionadas iniciales (si existen)
    _selectedStartDate = widget.initialStartDate;
    _selectedEndDate = widget.initialEndDate;

    // --- Simula la selección inicial de la imagen para demostración ---
    // Comenta o elimina estas líneas si no quieres forzar el inicio
    _selectedStartDate = DateTime(2025, 4, 2);
    _selectedEndDate = DateTime(2025, 5, 9);
    _displayedMonth1 = DateTime(2025, 4, 1); // Forzar Abril 2025
    _displayedMonth2 = DateTime(2025, 5, 1); // Forzar Mayo 2025
    // --- Fin de la simulación ---
  }

  void _previousMonths() {
    setState(() {
      // Calcular mes anterior correctamente
      if (_displayedMonth1.month == 1) {
        _displayedMonth1 = DateTime(_displayedMonth1.year - 1, 12, 1);
      } else {
        _displayedMonth1 = DateTime(
          _displayedMonth1.year,
          _displayedMonth1.month - 1,
          1,
        );
      }
      // El segundo mes siempre es el siguiente al primero
      if (_displayedMonth1.month == 12) {
        _displayedMonth2 = DateTime(_displayedMonth1.year + 1, 1, 1);
      } else {
        _displayedMonth2 = DateTime(
          _displayedMonth1.year,
          _displayedMonth1.month + 1,
          1,
        );
      }
    });
  }

  void _nextMonths() {
    setState(() {
      // Calcular mes siguiente correctamente
      if (_displayedMonth1.month == 12) {
        _displayedMonth1 = DateTime(_displayedMonth1.year + 1, 1, 1);
      } else {
        _displayedMonth1 = DateTime(
          _displayedMonth1.year,
          _displayedMonth1.month + 1,
          1,
        );
      }
      // El segundo mes siempre es el siguiente al primero
      if (_displayedMonth1.month == 12) {
        _displayedMonth2 = DateTime(_displayedMonth1.year + 1, 1, 1);
      } else {
        _displayedMonth2 = DateTime(
          _displayedMonth1.year,
          _displayedMonth1.month + 1,
          1,
        );
      }
    });
  }

  // Función básica para manejar la selección (solo simula por ahora)
  void _onDateSelected(DateTime date) {
    setState(() {
      if (_selectedStartDate == null ||
          (_selectedStartDate != null && _selectedEndDate != null)) {
        // Iniciar nueva selección o reiniciar
        _selectedStartDate = date;
        _selectedEndDate = null;
      } else if (_selectedEndDate == null &&
          date.isAfter(_selectedStartDate!)) {
        // Seleccionar fecha final
        _selectedEndDate = date;
        // --- Opcional: Cerrar y devolver el rango al seleccionar el final ---
        // Navigator.pop(context, DateTimeRange(start: _selectedStartDate!, end: _selectedEndDate!));
        // --- Fin opcional ---
      } else if (_selectedEndDate == null &&
          date.isBefore(_selectedStartDate!)) {
        // Si selecciona antes de la fecha de inicio, reiniciar con la nueva fecha
        _selectedStartDate = date;
        _selectedEndDate = null;
      } else if (_selectedEndDate == null &&
          date.isAtSameMomentAs(_selectedStartDate!)) {
        // Si selecciona la misma fecha de inicio, la establece como final (rango de un día)
        _selectedEndDate = date;
        // --- Opcional: Cerrar y devolver el rango al seleccionar el final ---
        // Navigator.pop(context, DateTimeRange(start: _selectedStartDate!, end: _selectedEndDate!));
        // --- Fin opcional ---
      }
    });
    // En una implementación real, aquí podrías cerrar el popup y devolver el rango
    // si ya tienes inicio y fin, o añadir botones OK/Cancelar.
    // print('Seleccionado: $date');
    // print('Inicio: $_selectedStartDate, Fin: $_selectedEndDate');
  }

  // --- Funciones de ayuda para construir la cuadrícula del mes ---

  int _daysInMonth(DateTime date) {
    // El día 0 del mes siguiente es el último día del mes actual
    var lastDay = DateTime(date.year, date.month + 1, 0);
    return lastDay.day;
  }

  // Obtiene el primer día de la semana (Lunes=1, Domingo=7) para el mes
  int _getFirstDayWeekday(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Evita el fondo blanco por defecto si el Card ya tiene color
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(
        20,
      ), // Añade un poco de margen alrededor del diálogo
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Card(
            color: Colors.white,
            // O usa Container si prefieres más control
            clipBehavior:
                Clip.antiAlias, // Para que el borde redondeado afecte al contenido
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Para que se ajuste al contenido
                children: [
                  // --- Fila de Navegación y Nombres de Mes ---
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ), // Ajuste padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _previousMonths,
                          tooltip: 'Mes anterior',
                          splashRadius: 20,
                          constraints:
                              const BoxConstraints(), // Quita constraints por defecto
                          padding: const EdgeInsets.all(8), // Ajusta padding
                        ),
                        // Se usa Expanded para que los textos tomen el espacio disponible
                        Expanded(
                          child: Text(
                            _monthYearFormat
                                .format(_displayedMonth1)
                                .capitalizeFirst(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        // Espacio flexible entre nombres de mes si es necesario, o fijo
                        const SizedBox(width: 24), // Espacio fijo
                        Expanded(
                          child: Text(
                            _monthYearFormat
                                .format(_displayedMonth2)
                                .capitalizeFirst(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _nextMonths,
                          tooltip: 'Mes siguiente',
                          splashRadius: 20,
                          constraints:
                              const BoxConstraints(), // Quita constraints por defecto
                          padding: const EdgeInsets.all(8), // Ajusta padding
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1), // Separador visual
                  const SizedBox(height: 10),

                  // --- Fila con las dos Cuadrículas de Mes ---
                  // ***** SE ELIMINÓ IntrinsicHeight DE AQUÍ *****
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildMonthGrid(_displayedMonth1)),
                      const SizedBox(width: 16), // Espacio entre calendarios
                      Expanded(child: _buildMonthGrid(_displayedMonth2)),
                    ],
                  ),

                  // ***** FIN DE LA SECCIÓN MODIFICADA *****
                  const SizedBox(height: 10),
                  // Puedes añadir botones de OK/Cancelar aquí si lo necesitas
                  /* Ejemplo de botones:
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       TextButton(
                         onPressed: () => Navigator.pop(context), // Cancelar
                         child: Text('Cancelar'),
                       ),
                       const SizedBox(width: 8),
                       ElevatedButton(
                         onPressed: (_selectedStartDate != null && _selectedEndDate != null)
                           ? () => Navigator.pop(context, DateTimeRange(start: _selectedStartDate!, end: _selectedEndDate!))
                           : null, // Habilitar solo si hay rango completo
                         child: Text('OK'),
                       ),
                     ],
                   )
                   */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget para construir una cuadrícula de mes ---
  Widget _buildMonthGrid(DateTime monthToDisplay) {
    final daysInMonth = _daysInMonth(monthToDisplay);
    // Ajuste para que Lunes sea el primer día (weekday 1)
    final firstWeekday = _getFirstDayWeekday(monthToDisplay);
    // Cuántos días del mes anterior mostrar (si Lunes es 1, Martes 2...)
    // (firstWeekday - 1) da el offset basado en 0 (Lunes=0)
    final leadingDays = (firstWeekday - 1 + 7) % 7; // Siempre positivo

    // Calcula el último día del mes anterior
    final prevMonthLastDay = DateTime(
      monthToDisplay.year,
      monthToDisplay.month,
      0,
    );
    final daysInPrevMonth = prevMonthLastDay.day;

    final List<Widget> dayWidgets = [];

    // --- Cabeceras de los días (lu, ma, mi...) ---
    dayWidgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ), // Más espacio vertical
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              _dayHeaders
                  .map(
                    (day) => SizedBox(
                      // Envuelve en SizedBox para asegurar ancho uniforme
                      width:
                          32, // Ancho fijo para la cabecera (ajusta si es necesario)
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11, // Un poco más pequeño
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );

    final List<Widget> dateCells = [];

    // Añadir días del mes anterior (atenuados)
    for (int i = 0; i < leadingDays; i++) {
      final day = daysInPrevMonth - leadingDays + 1 + i;
      final date = DateTime(prevMonthLastDay.year, prevMonthLastDay.month, day);
      dateCells.add(
        _buildDateCell(date, day, false, false, false, false),
      ); // Pasar fecha aunque sea de otro mes
    }

    // Añadir días del mes actual
    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(monthToDisplay.year, monthToDisplay.month, i);
      // Comprobaciones de selección (usando isAtSameMomentAs para comparar solo fecha)
      bool isSelectedStart =
          _selectedStartDate != null &&
          DateUtils.isSameDay(date, _selectedStartDate);

      bool isSelectedEnd =
          _selectedEndDate != null &&
          DateUtils.isSameDay(date, _selectedEndDate);

      bool isInRange =
          _selectedStartDate != null &&
          _selectedEndDate != null &&
          !DateUtils.isSameDay(date, _selectedStartDate) && // No es el inicio
          !DateUtils.isSameDay(date, _selectedEndDate) && // No es el fin
          date.isAfter(_selectedStartDate!) &&
          date.isBefore(_selectedEndDate!);

      dateCells.add(
        _buildDateCell(
          date,
          i,
          true,
          isSelectedStart,
          isSelectedEnd,
          isInRange,
        ),
      );
    }

    // Calcular días finales del mes siguiente (atenuados)
    final nextMonthFirstDay = DateTime(
      monthToDisplay.year,
      monthToDisplay.month + 1,
      1,
    );
    final totalCells = leadingDays + daysInMonth;
    // Celdas necesarias para llenar hasta 6 semanas (42 celdas) si es necesario
    // O simplemente completar la última fila (totalCells % 7)
    final trailingDays =
        (7 - (totalCells % 7)) % 7; // Celdas para completar la última fila

    for (int i = 0; i < trailingDays; i++) {
      final day = i + 1;
      final date = DateTime(
        nextMonthFirstDay.year,
        nextMonthFirstDay.month,
        day,
      );
      dateCells.add(
        _buildDateCell(date, day, false, false, false, false),
      ); // Pasar fecha aunque sea de otro mes
    }

    // Construir la cuadrícula
    dayWidgets.add(
      GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true, // Importante dentro de Column
        physics:
            const NeverScrollableScrollPhysics(), // No queremos scroll aquí
        children: dateCells,
        // Ajusta childAspectRatio para la proporción deseada. Cercano a 1 es cuadrado.
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0, // Espacio vertical entre celdas
        crossAxisSpacing: 2.0, // Espacio horizontal entre celdas
      ),
    );

    return Column(children: dayWidgets);
  }

  // --- Widget para construir una celda de día individual ---
  Widget _buildDateCell(
    DateTime? date,
    int dayNumber,
    bool isCurrentMonth,
    bool isSelectedStart,
    bool isSelectedEnd,
    bool isInRange,
  ) {
    Color textColor = isCurrentMonth ? Colors.black87 : Colors.grey.shade400;
    Color backgroundColor = Colors.transparent;
    BoxDecoration? decoration; // Null por defecto

    // Estilo base del texto
    TextStyle textStyle = TextStyle(
      color: textColor,
      fontSize: 13,
      fontWeight: FontWeight.normal,
    );

    // Determinar decoración y colores basados en la selección
    if (isSelectedStart && isSelectedEnd) {
      // Rango de un solo día
      backgroundColor = Colors.blue;
      textColor = Colors.white;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
      textStyle = textStyle.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      );
    } else if (isSelectedStart) {
      backgroundColor = Colors.blue;
      textColor = Colors.white;
      // Si no hay fecha final, es un círculo completo. Si la hay, es semicírculo izquierdo.
      decoration = BoxDecoration(
        color: backgroundColor,
        borderRadius:
            _selectedEndDate == null
                ? BorderRadius.circular(50) // Círculo completo si no hay fin
                : const BorderRadius.only(
                  // Semicírculo izquierdo
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
      );
      textStyle = textStyle.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      );
    } else if (isSelectedEnd) {
      backgroundColor = Colors.blue;
      textColor = Colors.white;
      // Siempre será semicírculo derecho si es la fecha final de un rango > 1 día
      decoration = BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      );
      textStyle = textStyle.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      );
    } else if (isInRange) {
      backgroundColor = Colors.blue.shade100; // Color más claro para el rango
      textColor = Colors.blue.shade900; // Texto oscuro en el rango
      decoration = BoxDecoration(
        color: backgroundColor,
      ); // Fondo rectangular sin bordes redondeados
      textStyle = textStyle.copyWith(color: textColor);
    }

    // Hacer interactivo solo los días del mes actual y que no estén deshabilitados
    bool isSelectable =
        isCurrentMonth; // Puedes añadir más lógica aquí (ej. fechas pasadas)

    Widget cellContent = Container(
      // Margen vertical para controlar el fondo del rango (isInRange)
      // Si no es parte del rango, el margen es 0, si lo es, se aplica.
      margin:
          isInRange
              ? const EdgeInsets.symmetric(vertical: 1.5)
              : EdgeInsets.zero,
      decoration: decoration,
      alignment: Alignment.center,
      child: Text(dayNumber.toString(), style: textStyle),
    );

    if (isSelectable && date != null) {
      return InkWell(
        onTap: () => _onDateSelected(date), // Habilitar selección real
        customBorder: const CircleBorder(), // Para efecto ripple circular
        child: cellContent,
      );
    } else {
      // Celda no interactiva para días fuera del mes o no seleccionables
      return cellContent;
    }
  }
}

// Extensión útil para capitalizar Strings (si no la tienes ya definida)
extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return "";
    // Maneja múltiples palabras si es necesario (ej. "mayo 2025" -> "Mayo 2025")
    List<String> parts = split(' ');
    if (parts.isEmpty) return "";
    parts[0] = "${parts[0][0].toUpperCase()}${parts[0].substring(1)}";
    return parts.join(' ');
  }
}
