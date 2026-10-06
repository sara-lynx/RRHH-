import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../widgets/auth_branding_panel.dart';
import '../widgets/password_requirements_widget.dart';

/// Niveles de seguridad para la nueva contraseña.
enum PasswordStrength { empty, weak, medium, strong }

/// Pantalla obligatoria de cambio de contraseña cuando un usuario recién creado
/// o con reseteo administrativo inicia sesión con `mustChangePassword = true`.
class ForcePasswordChangeScreen extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onPasswordChanged;

  const ForcePasswordChangeScreen({
    super.key,
    required this.authService,
    required this.onPasswordChanged,
  });

  @override
  State<ForcePasswordChangeScreen> createState() =>
      _ForcePasswordChangeScreenState();
}

class _ForcePasswordChangeScreenState extends State<ForcePasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
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
    _currentPasswordController.dispose();
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

  Future<void> _handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Las nuevas contraseñas no coinciden.';
      });
      return;
    }

    if (_newPasswordController.text.length < 8) {
      setState(() {
        _errorMessage = 'La nueva contraseña debe tener al menos 8 caracteres.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.authService.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        widget.onPasswordChanged();
      }
    } catch (e) {
      if (mounted) {
        String msg = 'No pudimos actualizar la contraseña. Intentá de nuevo.';
        final errorStr = e.toString();
        final lower = errorStr.toLowerCase();

        if (lower.contains('contraseña actual es incorrecta') ||
            lower.contains('clave actual') ||
            lower.contains('incorrecta') ||
            lower.contains('actual')) {
          msg = 'La contraseña actual es incorrecta.';
        } else if (lower.contains('debe tener al menos') ||
            lower.contains('caracteres') ||
            lower.contains('mayúscula') ||
            lower.contains('minúscula') ||
            lower.contains('número') ||
            lower.contains('símbolo') ||
            lower.contains('común') ||
            lower.contains('correo') ||
            lower.contains('nombre')) {
          msg = errorStr.replaceAll(RegExp(r'^.*Exception:\s*'), '').trim();
        } else if (errorStr.contains('al menos 8 caracteres')) {
          msg = 'La nueva contraseña debe tener al menos 8 caracteres.';
        }

        setState(() {
          _errorMessage = msg;
          _isLoading = false;
        });
      }
    }
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
            // Ícono superior en círculo translúcido
            Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  size: 24,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cabecera del Formulario
            Text(
              'Cambio de Contraseña Obligatorio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Por seguridad, debés cambiar tu contraseña temporal antes de continuar.',
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
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

            // Campo: Contraseña Actual
            Text(
              'CONTRASEÑA ACTUAL',
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
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresá tu contraseña actual';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

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
                hintText: 'Mínimo 8 caracteres',
                prefixIcon: const Icon(Icons.key_outlined, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresá la nueva contraseña';
                }
                if (value.length < 8) {
                  return 'La contraseña debe tener al menos 8 caracteres';
                }
                return null;
              },
            ),
            _buildStrengthMeter(isDark),
            const SizedBox(height: 12),
            PasswordRequirementsWidget(
              password: _newPasswordController.text,
              isCompact: true,
            ),
            const SizedBox(height: 20),

            // Campo: Confirmar Nueva Contraseña
            Text(
              'CONFIRMAR NUEVA CONTRASEÑA',
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
                hintText: 'Repetí la nueva contraseña',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirmá la nueva contraseña';
                }
                if (value != _newPasswordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // Botón de Actualizar
            FilledButton(
              onPressed: _isLoading ? null : _handleUpdatePassword,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Actualizar y continuar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
            ),
            const SizedBox(height: 20),

            // Nota de cumplimiento al pie (sin link de regreso)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Este cambio es obligatorio. La contraseña debe tener al menos 8 caracteres.',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
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
