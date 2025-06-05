import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CompactDropdownField<T> extends StatefulWidget {
  final String name;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final List<FormFieldValidator<T>> validators;
  final Function(T?)? onChanged;
  final T? initialValue;
  final double? dropdownWidth;

  const CompactDropdownField({
    super.key,
    required this.name,
    required this.items,
    this.hintText = 'Seleccione',
    this.validators = const [],
    this.onChanged,
    this.initialValue,
    this.dropdownWidth,
  });

  @override
  State<CompactDropdownField<T>> createState() =>
      _CompactDropdownFieldState<T>();
}

class _CompactDropdownFieldState<T> extends State<CompactDropdownField<T>> {
  bool _showDropdown = false;
  T? _selectedValue;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // ✅ Configuración ultra compacta
  static const double _itemHeight = 38.0; // Muy pequeño
  static const EdgeInsets _itemPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 2,
  ); // Padding mínimo
  static const double _fontSize = 13.0; // Fuente pequeña
  static const double _maxDropdownHeight = 200.0; // Altura máxima del dropdown

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
  }

  void _showOverlay() {
    try {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      setState(() => _showDropdown = true);
    } catch (e) {
      debugPrint('❌ CompactDropdown: Error en _showOverlay: $e');
    }
  }

  void _removeOverlay() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() => _showDropdown = false);
    } catch (e) {
      debugPrint('❌ CompactDropdown: Error en _removeOverlay: $e');
    }
  }

  void _selectItem(T value) {
    setState(() => _selectedValue = value);
    _removeOverlay();

    // Actualizar FormBuilder
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

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular dimensiones
    final validItems =
        widget.items.where((item) => item.value != null).toList();
    final itemCount = validItems.length;
    final idealHeight = itemCount * _itemHeight;
    final dropdownHeight = idealHeight.clamp(_itemHeight, _maxDropdownHeight);

    double dropdownWidth = widget.dropdownWidth ?? size.width;
    dropdownWidth = dropdownWidth.clamp(160.0, screenWidth * 0.9);

    // Posicionamiento
    double leftPosition = offset.dx;
    if (leftPosition + dropdownWidth > screenWidth - 16) {
      leftPosition = screenWidth - dropdownWidth - 16;
    }
    leftPosition = leftPosition.clamp(16.0, screenWidth - dropdownWidth - 16);

    double topPosition = offset.dy + size.height + 4;
    final spaceBelow = screenHeight - topPosition - 16;

    // Si no hay espacio abajo, mostrar arriba
    if (dropdownHeight > spaceBelow) {
      final spaceAbove = offset.dy - 16;
      if (spaceAbove > spaceBelow) {
        topPosition = offset.dy - dropdownHeight - 4;
      }
    }

    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Barrier para cerrar
              Positioned.fill(
                child: GestureDetector(
                  onTap: _removeOverlay,
                  child: Container(color: Colors.transparent),
                ),
              ),
              // Dropdown
              Positioned(
                left: leftPosition,
                top: topPosition,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: dropdownWidth,
                    height: dropdownHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildDropdownContent(
                        validItems,
                        dropdownHeight < idealHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildDropdownContent(
    List<DropdownMenuItem<T>> validItems,
    bool needsScroll,
  ) {
    if (validItems.isEmpty) {
      return Container(
        height: _itemHeight,
        alignment: Alignment.center,
        child: Text(
          'No hay opciones disponibles',
          style: TextStyle(color: Colors.grey, fontSize: _fontSize),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: needsScroll,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero, // ✅ Sin padding extra
        physics:
            needsScroll
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
        itemCount: validItems.length,
        separatorBuilder:
            (context, index) => const SizedBox.shrink(), // ✅ Sin separadores
        itemBuilder: (context, index) => _buildDropdownItem(validItems[index]),
      ),
    );
  }

  Widget _buildDropdownItem(DropdownMenuItem<T> item) {
    if (item.value == null) return const SizedBox.shrink();

    final isSelected = _selectedValue == item.value;

    return InkWell(
      onTap: () => _selectItem(item.value!),
      child: Container(
        height: _itemHeight, // ✅ Altura fija muy pequeña
        width: double.infinity,
        padding: _itemPadding, // ✅ Padding mínimo
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
                  fontSize: _fontSize, // ✅ Fuente pequeña
                  height: 1.0, // ✅ Altura de línea compacta
                ),
                overflow: TextOverflow.ellipsis,
                child: item.child,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check,
                size: 14, // ✅ Icono pequeño
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
          // Sincronizar estado
          if (field.value != _selectedValue) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() => _selectedValue = field.value);
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
                  fontSize: 14, // ✅ Fuente normal para el campo
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
        onChanged: (value) {
          setState(() => _selectedValue = value);
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}
