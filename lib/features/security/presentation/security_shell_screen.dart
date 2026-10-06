import 'package:flutter/material.dart';
import '../../rrhh/presentation/rrhh_shell_screen.dart';
import '../services/auth_service.dart';

/// Redirección al Shell oficial de RRHH desacoplado.
class SecurityShellScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;
  final AuthService? authService;

  const SecurityShellScreen({
    super.key,
    this.onToggleTheme,
    this.isDarkMode = false,
    this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return RrhhShellScreen(
      onToggleTheme: onToggleTheme,
      isDarkMode: isDarkMode,
      authService: authService,
    );
  }
}
