import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/resources/resources.dart';

class LeftPanel extends StatelessWidget {
  final AuthView authView;
  const LeftPanel({super.key, required this.authView});

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    List<Widget> highlights;

    switch (authView) {
      case AuthView.login:
        title = 'Bienvenido a Ho-Tech';
        subtitle =
            'Plataforma integral para la gestión de recursos humanos en empresas del sector hotelero.';
        highlights = [
          const FeatureHighlight(
            icon: LucideIcons.clipboardCheck,
            title: 'Gestión de solicitudes',
            description:
                'Administra todo tipo de solicitudes desde un solo lugar.',
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          const FeatureHighlight(
            icon: LucideIcons.users,
            title: 'Administración de personal',
            description: 'Contrataciones, evaluaciones, capacitaciones y más.',
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          const FeatureHighlight(
            icon: LucideIcons.chartNoAxesColumn,
            title: 'Informes y análisis',
            description:
                'Métricas e indicadores para tomar mejores decisiones.',
          ),
        ];
        break;
      case AuthView.register:
        title = 'Únete a Ho-Tech';
        subtitle =
            'Regístrate para acceder a una gestión hotelera simplificada y eficiente.';
        highlights = [
          const FeatureHighlight(
            icon: LucideIcons.userPlus,
            title: 'Registro Rápido',
            description:
                'Crea tu cuenta en pocos pasos y comienza a transformar tu gestión.',
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          const FeatureHighlight(
            icon: LucideIcons.shieldCheck,
            title: 'Seguridad Garantizada',
            description:
                'Tus datos están protegidos con los más altos estándares.',
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          const FeatureHighlight(
            icon: LucideIcons.layoutDashboard,
            title: 'Acceso Inmediato',
            description:
                'Una vez registrado, explora todas las funcionalidades que Ho-Tech te ofrece.',
          ),
        ];
        break;
      case AuthView.forgotPasswordEmail:
      case AuthView.forgotPasswordOtp:
        title = 'Recupera tu Acceso';
        subtitle =
            'Sigue los pasos para restablecer tu contraseña y volver a gestionar tus recursos humanos de forma eficiente.';
        highlights = [
          const FeatureHighlight(
            icon: LucideIcons.mailQuestion,
            title: 'Verificación Segura',
            description:
                'Ingresa tu correo para recibir un código de verificación y proteger tu cuenta.',
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          const FeatureHighlight(
            icon: LucideIcons.keyRound,
            title: 'Restablecimiento Fácil',
            description:
                'Con el código OTP, podrás crear una nueva contraseña de forma rápida y segura.',
          ),
          const SizedBox(height: AppDimensions.largeSpacing),
          const FeatureHighlight(
            icon: LucideIcons.lockKeyhole,
            title: 'Soporte Continuo',
            description:
                'Si tienes problemas, nuestro equipo de soporte está listo para ayudarte.',
          ),
        ];
        break;
    }

    return Container(
      color: AppColors.primaryBlue,
      padding: const EdgeInsets.all(AppDimensions.panelPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IconCenterWidget(),
          SizedBox(height: AppDimensions.largeSpacing * 1.5),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.itemSpacing / 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.largeSpacing * 1.5),
          ...highlights,
          const Spacer(),
        ],
      ),
    );
  }
}
