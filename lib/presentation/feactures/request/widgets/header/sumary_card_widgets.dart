import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/presentation/resources/resources.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: [
        _SummaryCard(
          title: 'Total Solicitudes',
          count: '124',
          icon: LucideIcons.fileSpreadsheet,
          iconColor: Colors.blue.shade700,
          iconBackgroundColor: const Color.fromARGB(57, 187, 222, 251),
        ),
        _SummaryCard(
          title: 'Pendientes',
          count: '28',
          icon: LucideIcons.clock,
          iconColor: Colors.orange.shade700,
          iconBackgroundColor: const Color.fromARGB(51, 255, 224, 178),
        ),
        _SummaryCard(
          title: 'Aprobadas',
          count: '86',
          icon: LucideIcons.circleCheck,
          iconColor: Colors.green.shade700,
          iconBackgroundColor: const Color.fromARGB(40, 200, 230, 201),
        ),
        _SummaryCard(
          title: 'Rechazadas',
          count: '10',
          icon: LucideIcons.triangleAlert,
          iconColor: Colors.red.shade700,
          iconBackgroundColor: const Color.fromARGB(40, 255, 205, 210),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final idealWidth = (constraints.maxWidth - 16.0 * 3) / 4;
        final minWidth = 180.0;

        return Container(
          width: idealWidth < minWidth ? constraints.maxWidth : idealWidth,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Columna de Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titlekpi,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      count,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 21,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Icono
              CircleAvatar(
                radius: 24,
                backgroundColor: iconBackgroundColor,
                child: Icon(icon, size: 24, color: iconColor),
              ),
            ],
          ),
        );
      },
    );
  }
}
