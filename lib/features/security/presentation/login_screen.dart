import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/exceptions/auth_exception.dart';
import '../services/auth_service.dart';
import 'recovery/forgot_password_screen.dart';
import 'widgets/auth_branding_panel.dart';

/// Pantalla de inicio de sesión empresarial diseñada según los tokens y estructura
/// canónica de Google Stitch, con adaptación dinámica para temas claro y oscuro.
class LoginScreen extends StatefulWidget {
  final AuthService? authService;
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;

  const LoginScreen({
    super.key,
    this.authService,
    this.onLoginSuccess,
    this.onToggleTheme,
    this.isDarkMode = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthService _authService;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
    _loadRememberMePreference();
  }

  Future<void> _loadRememberMePreference() async {
    final remember = await _authService.getRememberMePreference();
    final email = await _authService.getRememberedEmail();
    if (mounted) {
      setState(() {
        _rememberMe = remember;
        if (remember && email != null && email.isNotEmpty) {
          _emailController.text = email;
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (!mounted) return;

      if (!success) {
        setState(() {
          _errorMessage =
              'Credenciales inválidas. Verifica tu correo corporativo y contraseña.';
          _isLoading = false;
        });
        return;
      }

      // Login exitoso
      setState(() {
        _isLoading = false;
      });

      // Después de login exitoso, SOLO notificar al padre.
      // main.dart decide qué pantalla mostrar (declarativo).
      // NO hacer Navigator.push a MFA.
      widget.onLoginSuccess?.call();
    } catch (e) {
      if (mounted) {
        final errorStr = e.toString();
        String errorMsg;
        if (e is AuthException) {
          errorMsg = e.message;
        } else if (errorStr.contains('ACCOUNT_LOCKED') ||
            errorStr.contains('bloqueada') ||
            errorStr.contains('tooManyAttempts') ||
            errorStr.contains('AccountLockedException')) {
          errorMsg =
              'Tu cuenta está temporalmente bloqueada por múltiples intentos fallidos. Intentá de nuevo en unos minutos.';
        } else if (errorStr.contains('invalidCredentials')) {
          errorMsg =
              'Credenciales inválidas. Verifica tu correo corporativo y contraseña.';
        } else {
          errorMsg =
              'No fue posible conectar con el servidor. Revisa tu conexión o el estado del servicio.';
        }
        setState(() {
          _errorMessage = errorMsg;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    final formContent = Container(
      width: isDesktop ? 460 : double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 36 : 24,
        vertical: isDesktop ? 44 : 32,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera del Formulario
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Accede a tu cuenta corporativa',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onToggleTheme != null)
                  IconButton(
                    icon: Icon(
                      widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      size: 20,
                    ),
                    tooltip: 'Alternar tema',
                    onPressed: widget.onToggleTheme,
                  ),
              ],
            ),
            const SizedBox(height: 28),

            // Banner de Error
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.statusError.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.statusError.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppTheme.statusError,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppTheme.statusError,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Campo de Correo
            Text(
              'Correo Corporativo',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isDark
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'ejemplo@elitemultiservicios.com',
                prefixIcon: Icon(Icons.email_outlined, size: 20),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El correo corporativo es obligatorio';
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Formato de correo electrónico inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Campo de Contraseña
            Text(
              'Contraseña',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isDark
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••••••',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  tooltip: _obscurePassword
                      ? 'Mostrar contraseña'
                      : 'Ocultar contraseña',
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La contraseña es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Checkbox Recordarme + Link ¿Olvidaste tu contraseña?
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          value: _rememberMe,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (v) {
                            final newVal = v ?? false;
                            setState(() => _rememberMe = newVal);
                            _authService.saveRememberMePreference(
                              rememberMe: newVal,
                              email: _emailController.text,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          final newVal = !_rememberMe;
                          setState(() => _rememberMe = newVal);
                          _authService.saveRememberMePreference(
                            rememberMe: newVal,
                            email: _emailController.text,
                          );
                        },
                        child: Text(
                          'Recordarme',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ForgotPasswordScreen(
                              authService: _authService,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppTheme.accentBlue
                              : AppTheme.primaryBlue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Botón de Inicio de Sesión
            FilledButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // Pie informativo
            Center(
              child: Text(
                '¿No tienes cuenta? Contacta a tu administrador',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final desktopBranding = AuthBrandingPanel(isDesktop: true, isDark: isDark);
    final mobileBranding = AuthBrandingPanel(isDesktop: false, isDark: isDark);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            desktopBranding,
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 24,
                  ),
                  child: formContent,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                mobileBranding,
                formContent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
