import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomDropdownWidget extends StatefulWidget {
  final String title;
  final String headerTitle;
  final List<String> items;
  final Map<String, bool> selectedItems;
  final Function(Map<String, bool>) onSelectionChanged;

  const CustomDropdownWidget({
    super.key,
    required this.title,
    required this.headerTitle,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  });

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  bool _isDropdownVisible = false;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Map<String, bool> _localSelectedItems = {};

  @override
  void initState() {
    super.initState();
    // Crear una copia local del mapa de items seleccionados
    _updateLocalSelectedItems();
  }

  @override
  void didUpdateWidget(CustomDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizar la copia local cuando cambien las propiedades
    if (oldWidget.selectedItems != widget.selectedItems) {
      _updateLocalSelectedItems();
    }
  }

  void _updateLocalSelectedItems() {
    _localSelectedItems = Map<String, bool>.from(widget.selectedItems);
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isDropdownVisible) {
      _removeOverlay();
      setState(() {
        _isDropdownVisible = false;
      });
    } else {
      _showDropdown();
      setState(() {
        _isDropdownVisible = true;
      });
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showDropdown() {
    // Obtener la posición del botón
    final RenderBox? renderBox =
        _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    // Crear el overlay
    _overlayEntry = OverlayEntry(
      builder:
          (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // Cerrar dropdown al hacer clic fuera
              _removeOverlay();
              setState(() {
                _isDropdownVisible = false;
              });
            },
            child: Stack(
              children: [
                Positioned(
                  top: position.dy + size.height,
                  left: position.dx,
                  width: size.width,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: GestureDetector(
                      onTap: () {}, // Prevent tap from bubbling up
                      child: _buildDropdownContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    // Insertar el overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildDropdownContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabecera del dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.headerTitle,
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Divider(height: 1),

          // Lista de items
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    widget.items.map((item) {
                      return CheckboxListTile(
                        title: Text(item, style: const TextStyle(fontSize: 14)),
                        value: _localSelectedItems[item] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            _localSelectedItems[item] = value!;
                          });

                          // Notificar el cambio al widget padre
                          widget.onSelectionChanged(
                            Map<String, bool>.from(_localSelectedItems),
                          );
                        },
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        key: _dropdownKey,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _getDisplayText(),
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              _isDropdownVisible
                  ? LucideIcons.chevronUp
                  : LucideIcons.chevronDown,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar texto personalizado basado en las selecciones
  String _getDisplayText() {
    final selectedCount = _localSelectedItems.values.where((v) => v).length;

    if (selectedCount == 0) {
      return widget.title;
    } else if (selectedCount == 1) {
      final selectedItem =
          _localSelectedItems.entries.firstWhere((entry) => entry.value).key;
      return selectedItem;
    } else {
      return '$selectedCount ${widget.title.toLowerCase()} seleccionados';
    }
  }
}
