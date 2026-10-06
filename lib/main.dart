import 'dart:ui';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/security/presentation/login_screen.dart';
import 'features/security/presentation/recovery/force_password_change_screen.dart';
import 'features/security/presentation/recovery/mfa_verification_screen.dart';
import 'features/security/presentation/security_shell_screen.dart';
import 'features/security/services/auth_service.dart';

/// URL del backend. Configurable por --dart-define.
/// En desarrollo, default es localhost.
/// En producción, se pasa: --dart-define=SERVER_URL=https://elite-backend.onrender.com/
const String _serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://localhost:8080/',
);

/// Cliente global fuertemente tipado para comunicación RPC con Serverpod.
Client client = Client(_serverUrl)
  ..connectivityMonitor = FlutterConnectivityMonitor()
  ..authSessionManager = FlutterAuthSessionManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización obligatoria de credenciales y tokens JWT antes de resolver la vista
  await client.auth.initialize();

  runApp(const ProviderScope(child: EliteMultiserviciosApp()));
}

class EliteMultiserviciosApp extends StatefulWidget {
  const EliteMultiserviciosApp({super.key});

  @override
  State<EliteMultiserviciosApp> createState() => _EliteMultiserviciosAppState();
}

class _EliteMultiserviciosAppState extends State<EliteMultiserviciosApp> {
  ThemeMode _themeMode = ThemeMode.system;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

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
      title: 'Elite Multiservicios — Sistema Empresarial',
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
      home: AppAuthGate(
        authService: _authService,
        isDarkMode: isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

/// Compuerta reactiva de autenticación montada en la ruta raíz de MaterialApp.
/// Controla la transición en caliente entre Login, MFA, Cambio de Contraseña y Dashboard
/// sin requerir recarga manual del navegador (F5).
class AppAuthGate extends StatefulWidget {
  final AuthService authService;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const AppAuthGate({
    super.key,
    required this.authService,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<AppAuthGate> createState() => _AppAuthGateState();
}

class _AppAuthGateState extends State<AppAuthGate> {
  Future<_UserAuthState>? _authStateFuture;

  @override
  void initState() {
    super.initState();
    widget.authService.addListener(_onAuthChanged);
    if (client.auth.isAuthenticated) {
      _authStateFuture = _resolveAuthState();
    }
  }

  @override
  void didUpdateWidget(AppAuthGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authService != widget.authService) {
      oldWidget.authService.removeListener(_onAuthChanged);
      widget.authService.addListener(_onAuthChanged);
    }
  }

  @override
  void dispose() {
    widget.authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (!mounted) return;
    setState(() {
      if (client.auth.isAuthenticated) {
        _authStateFuture = _resolveAuthState();
      } else {
        _authStateFuture = null;
      }
    });
  }

  void _refreshAuthState() {
    if (!mounted) return;
    setState(() {
      if (client.auth.isAuthenticated) {
        _authStateFuture = _resolveAuthState();
      } else {
        _authStateFuture = null;
      }
    });
  }

  Future<_UserAuthState> _resolveAuthState() async {
    try {
      final user = await client.user.getCurrentUser();
      if (!user.mfaEnabled) {
        return _UserAuthState(user: user, isMfaVerified: true);
      }

      final isVerified = await widget.authService.isCurrentSessionMfaVerified();
      if (isVerified) {
        return _UserAuthState(user: user, isMfaVerified: true);
      }

      // La sesión activa NO tiene MFA verificado. Recuperar o emitir challenge.
      MfaChallengeResponse? challenge = widget.authService.currentMfaChallenge;
      if (challenge == null) {
        try {
          challenge = await widget.authService.checkMfaRequired(
            rememberMe: widget.authService.currentRememberMe,
            notify: false,
          );
        } catch (e) {
          if (kDebugMode) {
            print('[AppAuthGate] Error obteniendo challenge MFA: $e');
          }
        }
      }

      return _UserAuthState(
        user: user,
        isMfaVerified: false,
        mfaChallenge: challenge,
      );
    } catch (e) {
      // Si la sesión guardada en el cliente ya no es válida o expiró en el backend,
      // purgar la sesión local para evitar bucles de 500 y volver limpiamente al Login
      try {
        await widget.authService.logout();
      } catch (_) {}
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSignedIn = client.auth.isAuthenticated;
    if (!isSignedIn) {
      return LoginScreen(
        authService: widget.authService,
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
        onLoginSuccess: _refreshAuthState,
      );
    }

    _authStateFuture ??= _resolveAuthState();

    return FutureBuilder<_UserAuthState>(
      future: _authStateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          if (kDebugMode) {
            print(
              '[AppAuthGate] Error en FutureBuilder de authState: ${snapshot.error}',
            );
          }
          return LoginScreen(
            authService: widget.authService,
            isDarkMode: widget.isDarkMode,
            onToggleTheme: widget.onToggleTheme,
            onLoginSuccess: _refreshAuthState,
          );
        }
        final authState = snapshot.data!;
        final user = authState.user;

        // 1. PRIMERO: Si el usuario requiere MFA y la sesión NO está verificada
        if (user.mfaEnabled && !authState.isMfaVerified) {
          final challenge =
              authState.mfaChallenge ?? widget.authService.currentMfaChallenge;
          if (challenge != null) {
            return MfaVerificationScreen(
              authService: widget.authService,
              challengeId: challenge.challengeId,
              emailHint: challenge.emailHint,
              rememberMe: widget.authService.currentRememberMe,
              onMfaSuccess: () {
                widget.authService.markSessionMfaVerified();
                _refreshAuthState();
              },
            );
          } else {
            // El usuario requiere MFA pero el challenge aún se está obteniendo
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text('Generando código de seguridad...'),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _refreshAuthState,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        // 2. DESPUÉS: ¿Cambio obligatorio de contraseña?
        if (user.mustChangePassword) {
          return ForcePasswordChangeScreen(
            authService: widget.authService,
            onPasswordChanged: _refreshAuthState,
          );
        }

        // 3. Dashboard
        return SecurityShellScreen(
          authService: widget.authService,
          isDarkMode: widget.isDarkMode,
          onToggleTheme: widget.onToggleTheme,
        );
      },
    );
  }
}

class _UserAuthState {
  final AppUser user;
  final bool isMfaVerified;
  final MfaChallengeResponse? mfaChallenge;

  const _UserAuthState({
    required this.user,
    required this.isMfaVerified,
    this.mfaChallenge,
  });
}
