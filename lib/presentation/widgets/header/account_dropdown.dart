import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AccountDropdown extends StatelessWidget {
  final VoidCallback? onProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onHelp;
  final VoidCallback? onLogout;

  const AccountDropdown({
    super.key,
    this.onProfile,
    this.onSettings,
    this.onHelp,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header - Mi cuenta
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Mi cuenta',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
              indent: 16,
              endIndent: 16,
            ),

            // Menu items
            _buildMenuItem(
              icon: LucideIcons.user,
              title: 'Perfil',
              onTap: onProfile,
            ),
            _buildMenuItem(
              icon: LucideIcons.settings,
              title: 'Configuración',
              onTap: onSettings,
            ),
            _buildMenuItem(
              icon: LucideIcons.circleHelp,
              title: 'Ayuda',
              onTap: onHelp,
            ),

            // Divider before logout
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
              indent: 16,
              endIndent: 16,
            ),

            // Logout item
            _buildMenuItem(
              icon: LucideIcons.logOut,
              title: 'Cerrar sesión',
              onTap: onLogout,
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isLogout ? Colors.red.shade600 : Colors.black,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isLogout ? Colors.red.shade600 : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
