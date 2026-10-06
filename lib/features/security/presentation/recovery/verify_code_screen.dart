import 'dart:async';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../widgets/auth_branding_panel.dart';
import 'reset_password_screen.dart';

/// Pantalla de verificación de código de 8 dígitos (Paso 2 del flujo de recuperación)
/// implementada con fidelidad 1:1 según el diseño aprobado en Google Stitch.
class VerifyCodeScreen extends StatefulWidget {
  final AuthService authService;
  final UuidValue passwordResetRequestId;
  final String email;

  const VerifyCodeScreen({
    super.key,
    required this.authService,
    required this.passwordResetRequestId,
    required this.email,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  static const int _codeLength = 8;

  late final List<TextEditingController> _codeControllers;
  late final List<FocusNode> _codeFocusNodes;
  late UuidValue _currentRequestId;

  bool _isLoading = false;
  String? _errorMessage;
  int _resendCountdown = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _currentRequestId = widget.passwordResetRequestId;
    _codeControllers = List.generate(
      _codeLength,
      (_) => TextEditingController(),
    );
    _codeFocusNodes = List.generate(
      _codeLength,
      (_) => FocusNode(),
    );
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    for (final node in _codeFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _resendCountdown = 60);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendCountdown > 1) {
        setState(() => _resendCountdown--);
      } else {
        setState(() => _resendCountdown = 0);
        timer.cancel();
      }
    });
  }

  void _distributePastedCode(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    for (int i = 0; i < _codeLength; i++) {
      if (i < digits.length) {
        _codeControllers[i].text = digits[i];
      } else {
        _codeControllers[i].clear();
      }
    }

    if (digits.length >= _codeLength) {
      _codeFocusNodes.last.unfocus();
      _handleVerifyCode();
    } else {
      _codeFocusNodes[digits.length].requestFocus();
    }
  }

  Future<void> _handleVerifyCode() async {
    final code = _codeControllers.map((c) => c.text.trim()).join();

    if (code.length != _codeLength) {
      setState(() => _errorMessage = 'Ingresá los 8 dígitos del código');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await widget.authService.verifyPasswordResetCode(
        passwordResetRequestId: _currentRequestId,
        verificationCode: code,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(
              authService: widget.authService,
              finishPasswordResetToken: token,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final msg = e.toString();
        if (msg.contains('expired')) {
          setState(
            () => _errorMessage = 'El código expiró. Solicitá uno nuevo.',
          );
        } else if (msg.contains('tooManyAttempts')) {
          setState(
            () => _errorMessage =
                'Demasiados intentos. Solicitá un nuevo código.',
          );
        } else {
          setState(
            () => _errorMessage =
                'Código incorrecto. Verificalo e intentá de nuevo.',
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleResendCode() async {
    if (_resendCountdown > 0 || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newRequestId = await widget.authService.startPasswordReset(
        widget.email,
      );
      if (mounted) {
        setState(() {
          _currentRequestId = newRequestId;
          _isLoading = false;
          _errorMessage = null;
          for (final controller in _codeControllers) {
            controller.clear();
          }
        });
        _codeFocusNodes[0].requestFocus();
        _startCountdown();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Nuevo código de verificación enviado a tu correo.',
            ),
            backgroundColor: AppTheme.emeraldSuccess,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No pudimos reenviar el código. Intentá de nuevo.';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCodeInput(int index, bool isDark) {
    return SizedBox(
      width: 42,
      height: 52,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_codeControllers[index].text.isEmpty && index > 0) {
              _codeControllers[index - 1].clear();
              _codeFocusNodes[index - 1].requestFocus();
            }
          }
        },
        child: TextFormField(
          controller: _codeControllers[index],
          focusNode: _codeFocusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFCBD5E1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF1E3A8A),
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            if (value.length > 1) {
              _distributePastedCode(value);
              return;
            }

            if (value.isNotEmpty) {
              if (index < _codeLength - 1) {
                _codeFocusNodes[index + 1].requestFocus();
              } else {
                _codeFocusNodes[index].unfocus();
                _handleVerifyCode();
              }
            }
          },
        ),
      ),
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
        horizontal: isDesktop ? 36 : 20,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabecera del Formulario
          Text(
            'Verificar Código',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: 'Ingresá el código de 8 dígitos que enviamos a ',
                ),
                TextSpan(
                  text: widget.email,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
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

          // 8 Casillas de Código
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_codeLength, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == _codeLength - 1 ? 0 : 6,
                  ),
                  child: _buildCodeInput(index, isDark),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // Enlace de Reenvío con Countdown
          Center(
            child: _resendCountdown > 0
                ? Text.rich(
                    TextSpan(
                      text: '¿No recibiste el código? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                      children: [
                        TextSpan(
                          text: 'Reenviar en ${_resendCountdown}s',
                          style: TextStyle(
                            color: isDark
                                ? AppTheme.accentBlue
                                : const Color(0xFF1E3A8A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : TextButton(
                    onPressed: _isLoading ? null : _handleResendCode,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Reenviar código',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.accentBlue
                            : const Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 28),

          // Botón Primario: Verificar código
          FilledButton(
            onPressed: _isLoading ? null : _handleVerifyCode,
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
                          'Verificar código',
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
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
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
