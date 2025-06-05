import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/presentation/resources/resources.dart';

class FilterHeaderWidget extends StatefulWidget {
  final int initialTabIndex;
  final bool initialListView;
  final Function(int) onTabChanged;
  final Function(bool) onViewChanged;
  final VoidCallback? onFilterByDate;
  final VoidCallback? onDownload;

  const FilterHeaderWidget({
    super.key,
    this.initialTabIndex = 0,
    this.initialListView = true,
    required this.onTabChanged,
    required this.onViewChanged,
    this.onFilterByDate,
    this.onDownload,
  });

  @override
  State<FilterHeaderWidget> createState() => _FilterHeaderWidgetState();
}

class _FilterHeaderWidgetState extends State<FilterHeaderWidget> {
  late int _selectedTabIndex;
  late bool _isListView;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    _isListView = widget.initialListView;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      'Todas',
      'Pendientes',
      'Aprobadas',
      'Rechazadas',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final bool isWideScreen = constraints.maxWidth > 768;

        if (isMobile) {
          // Layout en columna para móvil con espaciado optimizado
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs arriba - optimizado para móvil
              _buildMobileTabs(tabs),
              const SizedBox(height: 16),
              // Botones abajo
              _buildMobileActions(),
            ],
          );
        }

        // Layout en fila para tablet y desktop
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Panel de tabs (izquierda)
            _buildDesktopTabs(tabs),

            // Botones del lado derecho según el tamaño de pantalla
            if (!isWideScreen)
              _buildTabletActions()
            else
              _buildDesktopActions(),
          ],
        );
      },
    );
  }

  // Tabs optimizados para móvil
  Widget _buildMobileTabs(List<String> tabs) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max, // Ocupa todo el ancho disponible
        children: List.generate(tabs.length, (index) {
          final bool isSelected = _selectedTabIndex == index;
          return Expanded(
            // Cada tab ocupa el mismo espacio
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                  widget.onTabChanged(index);
                });
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6, // Reducido de 16 a 6 para móvil
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ]
                          : null,
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center, // Centrar texto
                  style: TextStyle(
                    fontSize: 11, // Reducido de 13 a 11 para móvil
                    color: isSelected ? Colors.black : Colors.grey.shade700,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Tabs para desktop (mantiene el diseño original)
  Widget _buildDesktopTabs(List<String> tabs) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (index) {
          final bool isSelected = _selectedTabIndex == index;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
                widget.onTabChanged(index);
              });
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, // Mantiene el padding original para desktop
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ]
                        : null,
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 13, // Mantiene el tamaño original para desktop
                  color: isSelected ? Colors.black : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Acciones para móvil (< 600px)
  Widget _buildMobileActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          // Hace que el botón se adapte al espacio disponible
          child: OutlinedButton.icon(
            icon: const Icon(
              LucideIcons.calendarDays,
              size: 16,
              color: Colors.black,
            ),
            label: Text(
              'Filtrar por fecha',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12, // Reducido de 13 a 12 para móvil
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: widget.onFilterByDate,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ), // Reducido padding
              textStyle: const TextStyle(fontSize: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          icon: const Icon(LucideIcons.download, size: 16, color: Colors.black),
          label: const Text(
            'Descargar',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: widget.onDownload,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

  // Acciones para tablet (600px - 768px)
  Widget _buildTabletActions() {
    return Row(
      children: [
        // Botón de menú con opciones adicionales
        IconButton(
          icon: Icon(LucideIcons.menu, color: Colors.grey.shade700),
          onPressed: () {
            // TODO: Mostrar menú con opciones de filtro y descarga
          },
        ),
        // Botones de alternancia de vista
        ToggleButtons(
          isSelected: [_isListView, !_isListView],
          onPressed: (index) {
            setState(() {
              _isListView = index == 0;
              widget.onViewChanged(_isListView);
            });
          },
          borderRadius: BorderRadius.circular(6),
          constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
          selectedColor: AppColors.primaryPurple,
          color: Colors.grey.shade600,
          fillColor: AppColors.primaryPurple.withOpacity(0.1),
          children: const [
            Icon(LucideIcons.list, size: 18),
            Icon(LucideIcons.layoutGrid, size: 18),
          ],
        ),
      ],
    );
  }

  // Acciones para desktop (> 768px)
  Widget _buildDesktopActions() {
    return Row(
      children: [
        OutlinedButton.icon(
          icon: const Icon(
            LucideIcons.calendarDays,
            size: 16,
            color: Colors.black,
          ),
          label: Text(
            'Filtrar por fecha',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: widget.onFilterByDate,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          icon: const Icon(LucideIcons.download, size: 16, color: Colors.black),
          label: const Text(
            'Descargar',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: widget.onDownload,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ToggleButtons(
          isSelected: [_isListView, !_isListView],
          onPressed: (index) {
            setState(() {
              _isListView = index == 0;
              widget.onViewChanged(_isListView);
            });
          },
          borderRadius: BorderRadius.circular(6),
          constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
          selectedColor: Colors.white,
          color: Colors.grey.shade600,
          fillColor: AppColors.primaryBlue,
          children: const [
            Icon(LucideIcons.list, size: 18),
            Icon(LucideIcons.layoutGrid, size: 18),
          ],
        ),
      ],
    );
  }
}
