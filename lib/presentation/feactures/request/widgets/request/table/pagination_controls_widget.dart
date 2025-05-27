import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

class PaginationControls extends StatelessWidget {
  const PaginationControls({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Info Mostrando
        Text(
          'Mostrando 1-10 de 17 resultados', // TODO: Usar datos reales
          style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),

        // Controles
        Row(
          children: [
            Text(
              'Filas por página:', // TODO: Usar datos reales
              style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(width: 8),
            // Dropdown Filas por página (Placeholder)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: 10, // TODO: Usar valor real
                  items:
                      [10, 25, 50].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            '$value',
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                  onChanged: (int? newValue) {
                    // TODO: Cambiar filas por página
                  },
                  isDense: true, // Compacto
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                  icon: const Icon(LucideIcons.chevronDown, size: 16),
                ),
              ),
            ),
            const SizedBox(width: 24),

            // Botones de Paginación
            _buildPaginationButton(
              context,
              LucideIcons.chevronsLeft,
              onPressed: () {
                /* TODO: Primera página */
              },
              tooltip: 'Primera página',
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronLeft,
              onPressed: () {
                /* TODO: Página anterior */
              },
              tooltip: 'Página anterior',
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronRight,
              onPressed: () {
                /* TODO: Página siguiente */
              },
              tooltip: 'Página siguiente',
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronsRight,
              onPressed: () {
                /* TODO: Última página */
              },
              tooltip: 'Última página',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaginationButton(
    BuildContext context,
    IconData icon, {
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    // TODO: Deshabilitar botones si es necesario (primera/última página)
    final bool disabled = onPressed == null;
    final Color iconColor =
        disabled ? Colors.grey.shade400 : Colors.grey.shade700;

    return IconButton(
      icon: Icon(icon, size: 18),
      color: iconColor,
      onPressed: onPressed,
      tooltip: tooltip,
      splashRadius: 18,
      constraints: const BoxConstraints(
        minWidth: 30,
        minHeight: 30,
      ), // Tamaño consistente
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
