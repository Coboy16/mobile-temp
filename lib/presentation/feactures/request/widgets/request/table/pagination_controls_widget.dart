import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PaginationControls extends StatelessWidget {
  const PaginationControls({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: isMobile ? SizedBox.shrink() : _buildDesktopPagination(context),
    );
  }

  Widget _buildDesktopPagination(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Info
        Text(
          'Mostrando 1-10 de 17 resultados',
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
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronLeft,
              tooltip: 'Anterior',
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
            ),
            const SizedBox(width: 4),
            _buildPaginationButton(
              context,
              LucideIcons.chevronsRight,
              tooltip: 'Última',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobilePagination(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildPaginationButton(context, LucideIcons.chevronsLeft),
              const SizedBox(width: 4),
              _buildPaginationButton(context, LucideIcons.chevronLeft),
              const SizedBox(width: 4),
              _buildPageNumber(1, isActive: true),
              const SizedBox(width: 4),
              _buildPageNumber(2),
              const SizedBox(width: 4),
              _buildPaginationButton(context, LucideIcons.chevronRight),
              const SizedBox(width: 4),
              _buildPaginationButton(context, LucideIcons.chevronsRight),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageSizeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: 10,
          items:
              [10, 25, 50].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value', style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
          onChanged: (int? newValue) {
            // TODO: cambiar filas por página
          },
          isDense: true,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          icon: const Icon(LucideIcons.chevronDown, size: 16),
        ),
      ),
    );
  }

  Widget _buildPaginationButton(
    BuildContext context,
    IconData icon, {
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: IconButton(
          icon: Icon(icon, size: 16),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
