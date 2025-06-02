import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class InlineDatePickerField extends StatefulWidget {
  final String name;
  final String hintText;
  final List<FormFieldValidator<DateTime>> validators;
  final Function(DateTime?)? onChanged;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final double? calendarWidth;
  final double? calendarHeight; // NUEVA PROPIEDAD

  const InlineDatePickerField({
    super.key,
    required this.name,
    this.hintText = 'Seleccionar fecha',
    this.validators = const [],
    this.onChanged,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.calendarWidth,
    this.calendarHeight, // NUEVA PROPIEDAD OPCIONAL
  });

  @override
  State<InlineDatePickerField> createState() => _InlineDatePickerFieldState();
}

class _InlineDatePickerFieldState extends State<InlineDatePickerField> {
  final DateFormat _displayFormat = DateFormat('d \'de\' MMMM \'del\' y', 'es');
  bool _showCalendar = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialValue;
    _focusedDay = widget.initialValue ?? DateTime.now();
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleCalendar() {
    if (_showCalendar) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() {
      _showCalendar = !_showCalendar;
    });
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    // Usar el ancho personalizado o el ancho del campo como mínimo
    double calendarWidth = widget.calendarWidth ?? size.width;
    // Asegurar que el calendario no sea más pequeño que el campo
    calendarWidth = calendarWidth < size.width ? size.width : calendarWidth;

    // NUEVA FUNCIONALIDAD: Usar altura personalizada o valor por defecto
    double calendarHeight = widget.calendarHeight ?? 293;

    return OverlayEntry(
      builder:
          (context) => StatefulBuilder(
            builder: (context, setOverlayState) {
              return Stack(
                children: [
                  // Barrier invisible para cerrar cuando se toque fuera
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        _removeOverlay();
                        setState(() {
                          _showCalendar = false;
                        });
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  // El calendario con z-index alto
                  Positioned(
                    left: offset.dx,
                    top: offset.dy + size.height + 4,
                    width: calendarWidth,
                    child: Material(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: calendarHeight, // USAR ALTURA PERSONALIZADA
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[100]!,
                            width: 0.4,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCalendarHeader(setOverlayState),
                            _buildWeekdayHeaders(),
                            Expanded(child: _buildCalendarGrid()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });

    _removeOverlay();
    setState(() {
      _showCalendar = false;
    });

    // Actualizar el FormBuilderField
    FormBuilderState? formBuilderState;
    context.visitAncestorElements((element) {
      if (element.widget is FormBuilder) {
        formBuilderState =
            (element as StatefulElement).state as FormBuilderState?;
        return false;
      }
      return true;
    });

    formBuilderState?.fields[widget.name]?.didChange(date);
    widget.onChanged?.call(date);
  }

  Widget _buildCalendarHeader([StateSetter? setOverlayState]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(
                  _focusedDay.year,
                  _focusedDay.month - 1,
                  1,
                );
              });
              setOverlayState?.call(() {});
            },
            icon: const Icon(Icons.chevron_left),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          Text(
            DateFormat('MMMM yyyy', 'es').format(_focusedDay),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(
                  _focusedDay.year,
                  _focusedDay.month + 1,
                  1,
                );
              });
              setOverlayState?.call(() {});
            },
            icon: const Icon(Icons.chevron_right),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['lu', 'ma', 'mi', 'ju', 'vi', 'sá', 'do'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children:
            weekdays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    // Ajustar para que lunes sea el primer día (0 = lunes, 6 = domingo)
    int firstWeekday = firstDayOfMonth.weekday - 1;

    final daysInMonth = lastDayOfMonth.day;
    final totalCells = ((daysInMonth + firstWeekday) / 7).ceil() * 7;

    return Container(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemCount: totalCells,
        itemBuilder: (context, index) {
          final dayNumber = index - firstWeekday + 1;

          if (index < firstWeekday || dayNumber > daysInMonth) {
            return Container(); // Celdas vacías
          }

          final currentDate = DateTime(
            _focusedDay.year,
            _focusedDay.month,
            dayNumber,
          );
          final isSelected =
              _selectedDate != null &&
              currentDate.year == _selectedDate!.year &&
              currentDate.month == _selectedDate!.month &&
              currentDate.day == _selectedDate!.day;

          final isToday =
              currentDate.year == DateTime.now().year &&
              currentDate.month == DateTime.now().month &&
              currentDate.day == DateTime.now().day;

          // Verificar si la fecha está deshabilitada
          final isDisabled =
              (widget.firstDate != null &&
                  currentDate.isBefore(widget.firstDate!)) ||
              (widget.lastDate != null &&
                  currentDate.isAfter(widget.lastDate!));

          return GestureDetector(
            onTap: isDisabled ? null : () => _selectDate(currentDate),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Theme.of(context).primaryColor
                        : isToday
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border:
                    isToday && !isSelected
                        ? Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        )
                        : null,
              ),
              child: Center(
                child: Text(
                  '$dayNumber',
                  style: TextStyle(
                    color:
                        isDisabled
                            ? Colors.grey[400]
                            : isSelected
                            ? Colors.white
                            : isToday
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                    fontWeight:
                        isSelected || isToday
                            ? FontWeight.w600
                            : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: FormBuilderField<DateTime>(
        name: widget.name,
        initialValue: widget.initialValue,
        validator: FormBuilderValidators.compose(widget.validators),
        builder: (FormFieldState<DateTime> field) {
          // Sincronizar el estado interno con el valor del field
          if (field.value != _selectedDate) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _selectedDate = field.value;
                if (field.value != null) {
                  _focusedDay = field.value!;
                }
              });
            });
          }

          return InkWell(
            onTap: _toggleCalendar,
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                errorText: field.errorText,
              ),
              child: Text(
                field.value != null
                    ? _displayFormat.format(field.value!)
                    : widget.hintText,
                style: TextStyle(
                  color:
                      field.value != null
                          ? Theme.of(context).textTheme.titleMedium?.color ??
                              Colors.black87
                          : Colors.grey[600],
                ),
              ),
            ),
          );
        },
        onChanged: (value) {
          setState(() {
            _selectedDate = value;
            if (value != null) {
              _focusedDay = value;
            }
          });
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}
