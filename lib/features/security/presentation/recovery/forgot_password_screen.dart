import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../widgets/auth_branding_panel.dart';
import 'verify_code_screen.dart';

/// Pantalla de recuperación de contraseña empresarial (Paso 1: Solicitud de Código)
/// diseñada según las directivas del Design System y clonando el branding de LoginScreen.
class ForgotPasswordScreen extends StatefulWidget {
  final AuthService authService;

  const ForgotPasswordScreen({
    super.key,
    required this.authService,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final requestId = await widget.authService.startPasswordReset(email);

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VerifyCodeScreen(
              authService: widget.authService,
              passwordResetRequestId: requestId,
              email: email,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'No pudimos enviar el código. Verificá el correo o intentá de nuevo.';
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
            Text(
              'Recuperar Contraseña',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Te enviaremos un código de verificación a tu correo corporativo',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                height: 1.4,
              ),
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
              'Correo corporativo',
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
                hintText: 'tu.nombre@elitemultiservicios.com',
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
            const SizedBox(height: 28),

            // Botón Primario: Enviar código de recuperación
            FilledButton(
              onPressed: _isLoading ? null : _handleSendCode,
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
                  : const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enviar código de recuperación',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // Enlace Inferior: Volver al inicio de sesión
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text(
                  'Volver al inicio de sesión',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: isDark
                      ? AppTheme.accentBlue
                      : AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
