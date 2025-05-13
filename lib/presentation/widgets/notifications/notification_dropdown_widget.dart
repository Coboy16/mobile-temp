import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String description;
  final String timeAgo;
  final String id;

  NotificationModel({
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.id,
  });
}

// Datos de ejemplo
final List<NotificationModel> _sampleNotifications = [
  NotificationModel(
    id: '1',
    title: 'Nueva postulación',
    description: 'Miguel Rodríguez ha aplicado para Chef Ejecutivo',
    timeAgo: 'Hace 5 min',
  ),
  NotificationModel(
    id: '2',
    title: 'Entrevista programada',
    description: 'Entrevista con Laura Sánchez a las 10:00 AM',
    timeAgo: 'Hace 2 horas',
  ),
  NotificationModel(
    id: '3',
    title: 'Prueba completada',
    description: 'Carlos Jiménez completó la prueba psicométrica',
    timeAgo: 'Ayer',
  ),
];

class NotificationDropdown extends StatelessWidget {
  final VoidCallback? onViewAll; // Callback para "Ver todas"

  const NotificationDropdown({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor =
        Colors.deepPurple.shade400; // Color para "Ver todas" y badges

    return Material(
      // Usar Material para elevación y forma
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.white,
      child: ConstrainedBox(
        // Limita el tamaño
        constraints: const BoxConstraints(
          maxWidth: 350, // Ancho máximo
          maxHeight: 400, // Altura máxima antes de scroll
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Encoger para ajustar al contenido
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Título ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                'Notificaciones',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(height: 0.2, thickness: 1, color: Colors.grey.shade300),

            // --- Lista de Notificaciones ---
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _sampleNotifications.length,
                itemBuilder: (context, index) {
                  return _NotificationItem(
                    notification: _sampleNotifications[index],
                    badgeColor: primaryColor.withOpacity(0.1),
                    badgeTextColor: primaryColor,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(),
              ),
            ),

            const Divider(height: 1, thickness: 1),
            // --- Pie ("Ver todas") ---
            InkWell(
              onTap: onViewAll,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Ver todas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600, // Semi-bold
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final Color badgeColor;
  final Color badgeTextColor;

  const _NotificationItem({
    required this.notification,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      // Hacer cada item tappable si quieres
      onTap: () {
        print('Notificación Tapped: ${notification.id}');
        // Aquí podrías navegar o marcar como leída
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    notification.timeAgo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              notification.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
