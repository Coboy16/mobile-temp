import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/routes/app_router.dart';
import '/presentation/theme/app_theme.dart';
import '/presentation/bloc/bloc_init.dart';
import '/presentation/bloc/blocs.dart';
import '/core/core.dart';
import '/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.loadEnv();
  await initServiceLocator();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('es_ES', null);
  await initializeDateFormatting('en_US', null);
  await initializeDateFormatting('fr_FR', null);

  runApp(MultiBlocProvider(providers: getListBloc(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocaleBloc>().state.locale;
    final themeBloc = context.watch<ThemeBloc>();

    return MaterialApp.router(
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: const [
              Breakpoint(start: 0, end: 800, name: MOBILE),
              Breakpoint(start: 801, end: 1920, name: DESKTOP),
              Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
      title: 'Ho-tech del Caribe',
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: currentLocale,
      supportedLocales: LocaleBloc.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeBloc.themeMode,
    );
  }
}
