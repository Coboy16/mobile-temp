import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PaginationControls extends StatefulWidget {
  const PaginationControls({super.key});

  @override
  State<PaginationControls> createState() => _PaginationControlsState();
}

class _PaginationControlsState extends State<PaginationControls> {
  int _itemsPerPage =
      10; // Variable de estado para mantener el valor seleccionado

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child:
          isMobile
              ? _buildMobilePagination(context)
              : _buildDesktopPagination(context),
    );
  }

  Widget _buildDesktopPagination(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Info
        Text(
          'Mostrando 1-$_itemsPerPage de 17 resultados',
          style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),

        Row(
          children: [
            Text(
              'Filas por página:',
              style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            _buildPageSizeDropdown(),
            const SizedBox(width: 24),
            _buildPaginationButton(
              context,
              LucideIcons.chevronsLeft,
              tooltip: 'Primera',
              compact: false,
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronLeft,
              tooltip: 'Anterior',
              compact: false,
            ),
            const SizedBox(width: 4),
            _buildPageNumber(1, isActive: true),
            const SizedBox(width: 4),
            _buildPageNumber(2),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronRight,
              tooltip: 'Siguiente',
              compact: false,
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronsRight,
              tooltip: 'Última',
              compact: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobilePagination(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primera fila: Info a la izquierda, dropdown con padding a la derecha
        Row(
          children: [
            // Info de resultados
            Expanded(
              child: Text(
                'Mostrando 1-$_itemsPerPage de 17 resultados',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Espaciador para evitar que esté pegado al extremo
            const SizedBox(width: 12),

            // Dropdown con label
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Filas:',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                _buildPageSizeDropdown(compact: true),
              ],
            ),

            // Padding adicional para separar del extremo
            const SizedBox(width: 8),
          ],
        ),

        const SizedBox(height: 12),

        // Segunda fila: Botones de navegación centrados
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPaginationButton(
              context,
              LucideIcons.chevronsLeft,
              tooltip: 'Primera',
              compact: true,
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronLeft,
              tooltip: 'Anterior',
              compact: true,
            ),
            const SizedBox(width: 8),
            _buildPageNumber(1, isActive: true),
            const SizedBox(width: 4),
            _buildPageNumber(2),
            const SizedBox(width: 8),
            _buildPaginationButton(
              context,
              LucideIcons.chevronRight,
              tooltip: 'Siguiente',
              compact: true,
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronsRight,
              tooltip: 'Última',
              compact: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPageSizeDropdown({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: SizedBox(
          child: DropdownButton<int>(
            value: _itemsPerPage,
            items:
                [10, 25, 50].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      '$value',
                      style: TextStyle(
                        fontSize: compact ? 12 : 13,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (int? newValue) {
              if (newValue != null) {
                setState(() {
                  _itemsPerPage = newValue; // Actualizar el estado
                });
                // lógica adicional como callback a parent widget
                // widget.onItemsPerPageChanged?.call(newValue);
              }
            },
            isDense: true,
            style: TextStyle(
              fontSize: compact ? 12 : 13,
              color: Colors.black87,
            ),
            icon: Icon(LucideIcons.chevronDown, size: compact ? 14 : 16),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationButton(
    BuildContext context,
    IconData icon, {
    VoidCallback? onPressed,
    String? tooltip,
    bool compact = false,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child:
          compact
              ? // Estilo compacto para móvil (mismo tamaño que _buildPageNumber)
              GestureDetector(
                onTap: onPressed ?? () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Icon(icon, size: 16, color: Colors.black87),
                  ),
                ),
              )
              : // Estilo normal para desktop
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: IconButton(
                  icon: Icon(icon, size: 16),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  splashRadius: 20,
                  onPressed: onPressed ?? () {},
                ),
              ),
    );
  }

  Widget _buildPageNumber(int page, {bool isActive = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$page',
          style: TextStyle(
            fontSize: 13,
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
