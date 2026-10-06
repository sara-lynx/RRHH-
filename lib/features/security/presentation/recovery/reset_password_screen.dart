import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../widgets/auth_branding_panel.dart';
import '../widgets/password_requirements_widget.dart';

/// Niveles de seguridad para la nueva contraseña.
enum PasswordStrength { empty, weak, medium, strong }

/// Pantalla para el establecimiento de una nueva contraseña tras validar el código
/// (Paso 3 del flujo de recuperación de contraseña empresarial).
class ResetPasswordScreen extends StatefulWidget {
  final AuthService authService;
  final String finishPasswordResetToken;

  const ResetPasswordScreen({
    super.key,
    required this.authService,
    required this.finishPasswordResetToken,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  PasswordStrength _passwordStrength = PasswordStrength.empty;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_onPasswordChanged);
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    setState(() {
      _passwordStrength = _evaluateStrength(_newPasswordController.text);
    });
  }

  PasswordStrength _evaluateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.empty;
    if (password.length < 8) return PasswordStrength.weak;

    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    if (hasUpper && hasNumber) return PasswordStrength.strong;
    return PasswordStrength.medium;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.authService.finishPasswordReset(
        finishPasswordResetToken: widget.finishPasswordResetToken,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'No pudimos actualizar la contraseña. Intentá de nuevo.';
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final isDark = theme.brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: theme.cardTheme.color,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF10B981),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Contraseña actualizada',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ya podés iniciar sesión con tu nueva contraseña corporativa.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(dialogContext).popUntil(
                          (route) => route.isFirst,
                        );
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Volver al inicio de sesión',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStrengthMeter(bool isDark) {
    if (_passwordStrength == PasswordStrength.empty) {
      return const SizedBox.shrink();
    }

    Color activeColor;
    String label;
    int activeSegments;

    switch (_passwordStrength) {
      case PasswordStrength.weak:
        activeColor = const Color(0xFFEF4444);
        label = 'Seguridad: Débil';
        activeSegments = 1;
        break;
      case PasswordStrength.medium:
        activeColor = const Color(0xFFF59E0B);
        label = 'Seguridad: Media';
        activeSegments = 2;
        break;
      case PasswordStrength.strong:
        activeColor = const Color(0xFF10B981);
        label = 'Seguridad: Fuerte';
        activeSegments = 3;
        break;
      case PasswordStrength.empty:
        activeColor = Colors.transparent;
        label = '';
        activeSegments = 0;
    }

    final inactiveColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (index) {
            return Expanded(
              child: Container(
                height: 5,
                margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
                decoration: BoxDecoration(
                  color: index < activeSegments ? activeColor : inactiveColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            if (_passwordStrength == PasswordStrength.strong) ...[
              Icon(Icons.check, size: 14, color: activeColor),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: activeColor,
              ),
            ),
          ],
        ),
      ],
    );
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
              'Nueva Contraseña',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Elegí una contraseña segura para tu cuenta',
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

            // Campo: Nueva Contraseña
            Text(
              'NUEVA CONTRASEÑA',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.5,
                color: isDark
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  tooltip: _obscureNewPassword
                      ? 'Mostrar contraseña'
                      : 'Ocultar contraseña',
                  onPressed: () => setState(
                    () => _obscureNewPassword = !_obscureNewPassword,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La nueva contraseña es obligatoria';
                }
                if (value.length < 8) {
                  return 'La contraseña debe tener al menos 8 caracteres';
                }
                return null;
              },
            ),

            // Medidor de Fuerza de Contraseña
            _buildStrengthMeter(isDark),
            const SizedBox(height: 12),
            PasswordRequirementsWidget(
              password: _newPasswordController.text,
              isCompact: true,
            ),
            const SizedBox(height: 20),

            // Campo: Confirmar Contraseña
            Text(
              'CONFIRMAR CONTRASEÑA',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.5,
                color: isDark
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  tooltip: _obscureConfirmPassword
                      ? 'Mostrar contraseña'
                      : 'Ocultar contraseña',
                  onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor confirma la contraseña';
                }
                if (value != _newPasswordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // Botón Primario: Guardar contraseña
            FilledButton(
              onPressed: _isLoading ? null : _handleSave,
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
                            'Guardar contraseña',
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

            // Enlace Inferior: Cancelar y volver al login
            Center(
              child: TextButton.icon(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text(
                  'Cancelar y volver al login',
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
