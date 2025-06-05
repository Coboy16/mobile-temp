import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FilterBarMobile extends StatefulWidget {
  const FilterBarMobile({super.key});

  @override
  State<FilterBarMobile> createState() => _FilterBarMobileState();
}

class _FilterBarMobileState extends State<FilterBarMobile> {
  // Lista de tipos de solicitud (mocked data)
  final List<String> _tiposSolicitud = [
    'Cambio Alojamiento',
    'Cambio de horario',
    'Cambio de posición',
    'Cambio de propina',
    'Cartas',
    'Licencias Médicas',
    'Permisos',
    'Vacaciones',
    'Uniformes',
  ];

  // Lista de estados (mocked data)
  final List<String> _estados = ['Pendiente', 'Aprobada', 'Rechazada'];

  // Estado para controlar los checkboxes seleccionados
  final Map<String, bool> _tiposSolicitudSeleccionados = {};
  final Map<String, bool> _estadosSeleccionados = {};

  // Controller para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar todos como no seleccionados
    for (var tipo in _tiposSolicitud) {
      _tiposSolicitudSeleccionados[tipo] = false;
    }
    for (var estado in _estados) {
      _estadosSeleccionados[estado] = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de Búsqueda (parte superior)
            _buildSearchField(context),

            const SizedBox(height: 16),

            // Row con botones (parte inferior)
            Row(
              children: [
                // Botón Filtro Avanzado
                Expanded(child: _buildAdvancedFilterButton(context)),

                const SizedBox(width: 12),

                // Botón Limpiar
                _buildClearButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey.shade50,
      ),
      child: FormBuilderTextField(
        name: 'search',
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar solicitudes...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            LucideIcons.search,
            size: 20,
            color: Colors.grey.shade600,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 4,
          ),
        ),
        onChanged: (value) {
          // Envía el valor al bloc si lo necesitas
        },
      ),
    );
  }

  Widget _buildAdvancedFilterButton(BuildContext context) {
    return Container(
      height: 44,
      child: ElevatedButton(
        onPressed: () {
          // Implementar lógica para mostrar filtros avanzados
          _showAdvancedFiltersModal(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          side: BorderSide(color: Colors.grey.shade300, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Text(
          'Filtro avanzado',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return Container(
      height: 44,
      child: TextButton(
        onPressed: () {
          setState(() {
            // Resetear todos los filtros
            for (var tipo in _tiposSolicitud) {
              _tiposSolicitudSeleccionados[tipo] = false;
            }
            for (var estado in _estados) {
              _estadosSeleccionados[estado] = false;
            }
            // Limpiar el campo de búsqueda
            _searchController.clear();
            // Enviar el evento para limpiar los filtros al bloc
          });
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Text(
          'Limpiar',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _showAdvancedFiltersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder:
                (context, scrollController) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle del modal
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Título
                      const Text(
                        'Filtros Avanzados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Contenido scrolleable
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            // Sección Tipos de Solicitud
                            _buildFilterSection(
                              'Tipos de Solicitud',
                              _tiposSolicitud,
                              _tiposSolicitudSeleccionados,
                            ),

                            const SizedBox(height: 24),

                            // Sección Estados
                            _buildFilterSection(
                              'Estados',
                              _estados,
                              _estadosSeleccionados,
                            ),
                          ],
                        ),
                      ),

                      // Botones de acción
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Aplicar filtros
                                Navigator.pop(context);
                              },
                              child: const Text('Aplicar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> items,
    Map<String, bool> selectedItems,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => CheckboxListTile(
            title: Text(item),
            value: selectedItems[item] ?? false,
            onChanged: (bool? value) {
              setState(() {
                selectedItems[item] = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
