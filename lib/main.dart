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

class EliteMultiserviciosApp extends StatefulWidget {
  const EliteMultiserviciosApp({super.key});

  @override
  State<EliteMultiserviciosApp> createState() => _EliteMultiserviciosAppState();
}

class _EliteMultiserviciosAppState extends State<EliteMultiserviciosApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return MaterialApp(
      title: 'Elite Multiservicios — Recursos Humanos (RRHH)',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
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
      home: RrhhShellScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: isDark,
      ),
    );
  }
}
