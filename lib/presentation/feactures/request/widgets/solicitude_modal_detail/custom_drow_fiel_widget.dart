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
    debugPrint('🔧 CustomDropdown: RenderBox size: $size, offset: $offset');

    // Obtener el ancho de la pantalla para calcular límites
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calcular ancho seguro del dropdown - usar un valor fijo mínimo
    double dropdownWidth = widget.dropdownWidth ?? 200;
    double minWidth = 160;

    // Si el ancho del campo es razonable, usarlo como base
    if (size.width > minWidth) {
      dropdownWidth = dropdownWidth < size.width ? size.width : dropdownWidth;
    } else {
      dropdownWidth = dropdownWidth < minWidth ? minWidth : dropdownWidth;
    }

    // Verificar que no exceda el ancho de pantalla
    double availableWidth = screenWidth - offset.dx - 20;
    if (dropdownWidth > availableWidth) {
      dropdownWidth = availableWidth > minWidth ? availableWidth : minWidth;
    }

    // Ajustar posición si es necesario
    double leftPosition = offset.dx;
    if (leftPosition + dropdownWidth > screenWidth - 20) {
      leftPosition = screenWidth - dropdownWidth - 20;
    }
    leftPosition = leftPosition < 10 ? 10 : leftPosition;

    // Calcular altura del dropdown
    double itemHeight = 48.0;
    double maxHeight = widget.maxVisibleItems * itemHeight;
    double actualHeight = widget.items.length * itemHeight;
    double baseDropdownHeight =
        actualHeight > maxHeight ? maxHeight : actualHeight;

    // Calcular espacio disponible hacia abajo
    final availableSpaceDown = screenHeight - offset.dy - size.height - 20;
    double dropdownHeight =
        baseDropdownHeight > availableSpaceDown
            ? availableSpaceDown
            : baseDropdownHeight;

    // Asegurar altura mínima
    dropdownHeight = dropdownHeight < 100 ? 100 : dropdownHeight;

    debugPrint(
      '🔧 CustomDropdown: Creando OverlayEntry con needsScroll: ${actualHeight > maxHeight}',
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
                // El dropdown con z-index alto
                Positioned(
                  left: leftPosition,
                  top: offset.dy + size.height + 4,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: dropdownWidth,
                      height: dropdownHeight,
                      constraints: BoxConstraints(
                        maxHeight: availableSpaceDown,
                        maxWidth: dropdownWidth,
                        minWidth: minWidth,
                        minHeight: 100,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Builder(
                        builder: (context) {
                          return _buildDropdownContent(
                            setOverlayState,
                            actualHeight > maxHeight,
                          );
                        },
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
        child: const Text('No hay opciones disponibles'),
      );
    }

    // Crear lista de widgets válidos
    final validItems =
        widget.items
            .where((item) => item.value != null)
            .map((item) => _buildDropdownItem(item))
            .toList();

    debugPrint('🔧 CustomDropdown: validItems.length: ${validItems.length}');

    if (!needsScroll) {
      debugPrint(
        '🔧 CustomDropdown: No necesita scroll, mostrando Column simple',
      );
      return Column(mainAxisSize: MainAxisSize.min, children: validItems);
    }

    debugPrint(
      '🔧 CustomDropdown: Necesita scroll, usando SingleChildScrollView SIN controller',
    );

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(mainAxisSize: MainAxisSize.min, children: validItems),
    );
  }

  Widget _buildDropdownItem(DropdownMenuItem<T> item) {
    if (item.value == null) {
      return const SizedBox.shrink();
    }

    bool isSelected = _selectedValue == item.value;
    debugPrint('🔧 CustomDropdown: Item isSelected: $isSelected');

    return InkWell(
      onTap: () {
        debugPrint('🔧 CustomDropdown: Item tapped - value: ${item.value}');
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
        child:
            isSelected
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        child: item.child,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                )
                : Align(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    child: item.child,
                  ),
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
