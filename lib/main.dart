import 'dart:ui';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/rrhh/presentation/rrhh_shell_screen.dart';

/// URL del backend. Configurable opcionalmente por --dart-define.
const String _serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://localhost:8080/',
);

/// Cliente global disponible para Serverpod.
Client client = Client(_serverUrl);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: EliteMultiserviciosApp()));
}

class EliteMultiserviciosApp extends StatelessWidget {
  const EliteMultiserviciosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elite Multiservicios — Recursos Humanos (RRHH)',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown,
        },
      ),
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const RrhhShellScreen(
        isDarkMode: false,
      ),
    );
  }
}
