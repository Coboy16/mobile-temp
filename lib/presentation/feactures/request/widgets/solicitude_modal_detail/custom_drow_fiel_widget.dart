import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomDropdownField<T> extends StatefulWidget {
  final String name;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final List<FormFieldValidator<T>> validators;
  final Function(T?)? onChanged;
  final T? initialValue;
  final double? dropdownWidth;
  final int maxVisibleItems;

  const CustomDropdownField({
    super.key,
    required this.name,
    required this.items,
    this.hintText = 'Seleccione',
    this.validators = const [],
    this.onChanged,
    this.initialValue,
    this.dropdownWidth,
    this.maxVisibleItems = 6,
  });

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  bool _showDropdown = false;
  T? _selectedValue;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_showDropdown) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() {
      _showDropdown = !_showDropdown;
    });
  }

  void _showOverlay() {
    try {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } catch (e) {
      debugPrint('❌ CustomDropdown: Error en _showOverlay: $e');
    }
  }

  void _removeOverlay() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      debugPrint('❌ CustomDropdown: Error en _removeOverlay: $e');
    }
  }

  void _selectItem(T value) {
    setState(() {
      _selectedValue = value;
    });

    _removeOverlay();
    setState(() {
      _showDropdown = false;
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

    formBuilderState?.fields[widget.name]?.didChange(value);
    widget.onChanged?.call(value);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return OverlayEntry(builder: (_) => const SizedBox());
    }

    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    // Obtener dimensiones de pantalla seguras
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final padding = mediaQuery.padding;
    final viewInsets = mediaQuery.viewInsets;

    // Calcular área segura de pantalla
    final safeTop = padding.top;
    final safeBottom = padding.bottom + viewInsets.bottom;
    final availableHeight = screenHeight - safeTop - safeBottom;
    final safeMargin = 16.0; // Margen de seguridad

    // Calcular ancho del dropdown
    double dropdownWidth = widget.dropdownWidth ?? size.width;
    const double minWidth = 160;
    const double maxWidthRatio = 0.9;

    dropdownWidth = dropdownWidth.clamp(minWidth, screenWidth * maxWidthRatio);

    // Ajustar posición horizontal
    double leftPosition = offset.dx;
    if (leftPosition + dropdownWidth > screenWidth - safeMargin) {
      leftPosition = screenWidth - dropdownWidth - safeMargin;
    }
    leftPosition = leftPosition.clamp(
      safeMargin,
      screenWidth - dropdownWidth - safeMargin,
    );

    // Calcular dimensiones del contenido
    const double itemHeight = 48.0;
    final int itemCount =
        widget.items.where((item) => item.value != null).length;
    final double idealHeight = itemCount * itemHeight;
    final double maxAllowedHeight = widget.maxVisibleItems * itemHeight;
    final double contentHeight = idealHeight.clamp(
      itemHeight,
      maxAllowedHeight,
    );

    // Calcular espacios disponibles arriba y abajo
    final double spaceBelow =
        availableHeight - (offset.dy - safeTop) - size.height - safeMargin;
    final double spaceAbove = (offset.dy - safeTop) - safeMargin;

    // Decidir si mostrar arriba o abajo
    bool showAbove = false;
    double finalHeight = contentHeight;
    double topPosition = offset.dy + size.height + 4;

    if (contentHeight > spaceBelow) {
      if (spaceAbove > spaceBelow && spaceAbove >= itemHeight * 2) {
        // Mostrar arriba si hay más espacio arriba
        showAbove = true;
        finalHeight = contentHeight.clamp(itemHeight * 2, spaceAbove);
        topPosition = offset.dy - finalHeight - 4;
      } else {
        // Mostrar abajo pero ajustar altura
        finalHeight = spaceBelow.clamp(itemHeight * 2, contentHeight);
      }
    }

    debugPrint(
      '🔧 CustomDropdown: Calculado - showAbove: $showAbove, finalHeight: $finalHeight',
    );

    return OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setOverlayState) {
            return Stack(
              children: [
                // Barrier invisible para cerrar cuando se toque fuera
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      _removeOverlay();
                      setState(() {
                        _showDropdown = false;
                      });
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),
                // El dropdown
                Positioned(
                  left: leftPosition,
                  top: topPosition,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: dropdownWidth,
                      height: finalHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildDropdownContent(
                          setOverlayState,
                          finalHeight < idealHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownContent(StateSetter setOverlayState, bool needsScroll) {
    if (widget.items.isEmpty) {
      return Container(
        height: 48,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: const Text(
          'No hay opciones disponibles',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Crear lista de widgets válidos
    final validItems =
        widget.items
            .where((item) => item.value != null)
            .map((item) => _buildDropdownItem(item))
            .toList();

    if (validItems.isEmpty) {
      return Container(
        height: 48,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: const Text(
          'No hay opciones válidas',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Usar siempre ListView para evitar problemas de overflow
    // El contenedor padre ya tiene altura fija, así que ListView respetará esas constraints
    return Scrollbar(
      thumbVisibility: needsScroll,
      child: ListView.builder(
        shrinkWrap: true,
        physics:
            needsScroll
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
        itemCount: validItems.length,
        itemBuilder: (context, index) => validItems[index],
      ),
    );
  }

  Widget _buildDropdownItem(DropdownMenuItem<T> item) {
    if (item.value == null) {
      return const SizedBox.shrink();
    }

    bool isSelected = _selectedValue == item.value;

    return InkWell(
      onTap: () {
        _selectItem(item.value!);
      },
      child: Container(
        height: 48,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  color:
                      isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                child: item.child,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (_selectedValue == null) return widget.hintText;

    try {
      final selectedItem = widget.items.firstWhere(
        (item) => item.value == _selectedValue,
      );

      // Extraer el texto del widget child
      if (selectedItem.child is Text) {
        return (selectedItem.child as Text).data ?? widget.hintText;
      }

      return _selectedValue.toString();
    } catch (e) {
      return widget.hintText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: FormBuilderField<T>(
        name: widget.name,
        initialValue: widget.initialValue,
        validator: FormBuilderValidators.compose(widget.validators),
        builder: (FormFieldState<T> field) {
          // Sincronizar el estado interno con el valor del field
          if (field.value != _selectedValue) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _selectedValue = field.value;
              });
            });
          }

          return InkWell(
            onTap: _toggleDropdown,
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: widget.hintText,
                suffixIcon: Icon(
                  _showDropdown
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                ),
                errorText: field.errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                _getDisplayText(),
                style: TextStyle(
                  color:
                      field.value != null
                          ? Theme.of(context).textTheme.titleMedium?.color ??
                              Colors.black87
                          : Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
          });
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}
