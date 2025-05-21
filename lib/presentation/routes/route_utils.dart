import '/presentation/widgets/sidebar/sidebar_menu_constants.dart';
import 'app_router.dart'; // Asegúrate que AppRoutes esté accesible

// Función existente
String getGoRouterNameForSidebarRoute(String sidebarRouteConstant) {
  switch (sidebarRouteConstant) {
    case AppSidebarMenuRoutes.portalEmpleado:
    case AppSidebarMenuRoutes.solicitudes:
      return AppRoutes.homeRequestName;
    case AppSidebarMenuRoutes.comprobantesPago:
      return AppRoutes.homeCheckPaymentName;
    case AppSidebarMenuRoutes.informeCursos:
      return AppRoutes.homeInformeCursosName;
    case AppSidebarMenuRoutes.colaAprobacion:
      return AppRoutes.homeColaAprobacionName;

    case AppSidebarMenuRoutes.reclutamiento:
    case AppSidebarMenuRoutes.ofertasTrabajo:
      return AppRoutes.homeOfertasTrabajoName;
    case AppSidebarMenuRoutes.candidatos:
      return AppRoutes.homeCandidatosName;
    case AppSidebarMenuRoutes.portalPublico:
      return AppRoutes.homePortalPublicoName;
    case AppSidebarMenuRoutes.pruebasPsicometricas:
      return AppRoutes.homePruebasPsicometricasName;
    case AppSidebarMenuRoutes.ajustes:
      return AppRoutes.homeAjustesName;

    case AppSidebarMenuRoutes.portalCandidato:
    case AppSidebarMenuRoutes.subitemCandidato:
      return AppRoutes.homeSubitemCandidatoName;
    case AppSidebarMenuRoutes.misPostulaciones:
      return AppRoutes.homeMisPostulacionesName;
    case AppSidebarMenuRoutes.miPerfilCandidato:
      return AppRoutes.homeMiPerfilCandidatoName;

    case AppSidebarMenuRoutes.evaluacionDesempeno:
      return AppRoutes.homeEvaluacionDesempenoName;
    case AppSidebarMenuRoutes.consolidacion:
      return AppRoutes.homeConsolidacionName;
    case AppSidebarMenuRoutes.calculosImpositivos:
      return AppRoutes.homeCalculosImpositivosName;

    case AppSidebarMenuRoutes.perfilUsuarioSistema:
      return AppRoutes.homeProfileUserSystemName;

    case AppSidebarMenuRoutes.ayudaSoporte:
      return AppRoutes.homeAyudaSoporteName;
    case AppSidebarMenuRoutes.configuracion:
      return AppRoutes.homeConfiguracionName;

    default:
      return AppRoutes.homeRequestName;
  }
}

// NUEVA FUNCIÓN
String getGoRouterPathForSidebarRoute(String sidebarRouteConstant) {
  switch (sidebarRouteConstant) {
    case AppSidebarMenuRoutes.portalEmpleado:
    case AppSidebarMenuRoutes.solicitudes:
      return '${AppRoutes.home}/${AppRoutes.homeSubRequest}';
    case AppSidebarMenuRoutes.comprobantesPago:
      return '${AppRoutes.home}/${AppRoutes.homeSubCheckPayment}';
    case AppSidebarMenuRoutes.informeCursos:
      return '${AppRoutes.home}/${AppRoutes.homeSubInformeCursos}';
    case AppSidebarMenuRoutes.colaAprobacion:
      return '${AppRoutes.home}/${AppRoutes.homeSubColaAprobacion}';

    case AppSidebarMenuRoutes.reclutamiento:
    case AppSidebarMenuRoutes.ofertasTrabajo:
      return '${AppRoutes.home}/${AppRoutes.homeSubOfertasTrabajo}';
    case AppSidebarMenuRoutes.candidatos:
      return '${AppRoutes.home}/${AppRoutes.homeSubCandidatos}';
    case AppSidebarMenuRoutes.portalPublico:
      return '${AppRoutes.home}/${AppRoutes.homeSubPortalPublico}';
    case AppSidebarMenuRoutes.pruebasPsicometricas:
      return '${AppRoutes.home}/${AppRoutes.homeSubPruebasPsicometricas}';
    case AppSidebarMenuRoutes.ajustes:
      return '${AppRoutes.home}/${AppRoutes.homeSubAjustes}';

    case AppSidebarMenuRoutes.portalCandidato:
    case AppSidebarMenuRoutes.subitemCandidato:
      return '${AppRoutes.home}/${AppRoutes.homeSubSubitemCandidato}';
    case AppSidebarMenuRoutes.misPostulaciones:
      return '${AppRoutes.home}/${AppRoutes.homeSubMisPostulaciones}';
    case AppSidebarMenuRoutes.miPerfilCandidato:
      return '${AppRoutes.home}/${AppRoutes.homeSubMiPerfilCandidato}';

    case AppSidebarMenuRoutes.evaluacionDesempeno:
      return '${AppRoutes.home}/${AppRoutes.homeSubEvaluacionDesempeno}';
    case AppSidebarMenuRoutes.consolidacion:
      return '${AppRoutes.home}/${AppRoutes.homeSubConsolidacion}';
    case AppSidebarMenuRoutes.calculosImpositivos:
      return '${AppRoutes.home}/${AppRoutes.homeSubCalculosImpositivos}';

    case AppSidebarMenuRoutes.perfilUsuarioSistema:
      return '${AppRoutes.home}/${AppRoutes.homeSubProfileUserSystem}';

    case AppSidebarMenuRoutes.ayudaSoporte:
      return '${AppRoutes.home}/${AppRoutes.homeSubAyudaSoporte}';
    case AppSidebarMenuRoutes.configuracion:
      return '${AppRoutes.home}/${AppRoutes.homeSubConfiguracion}';

    default:
      return '${AppRoutes.home}/${AppRoutes.homeSubRequest}'; // Fallback
  }
}
