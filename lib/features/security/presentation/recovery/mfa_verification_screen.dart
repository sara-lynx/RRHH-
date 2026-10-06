import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../widgets/auth_branding_panel.dart';

/// Pantalla de verificación de autenticación multifactor (MFA / 2FA).
/// Implementada con fidelidad 1:1 según el diseño aprobado en Google Stitch.
class MfaVerificationScreen extends StatefulWidget {
  final AuthService authService;
  final String challengeId;
  final String emailHint;
  final bool rememberMe;
  final VoidCallback? onMfaSuccess;

  const MfaVerificationScreen({
    super.key,
    required this.authService,
    required this.challengeId,
    required this.emailHint,
    required this.rememberMe,
    this.onMfaSuccess,
  });

  @override
  State<MfaVerificationScreen> createState() => _MfaVerificationScreenState();
}

class _MfaVerificationScreenState extends State<MfaVerificationScreen> {
  static const int _codeLength = 6;

  late final List<TextEditingController> _codeControllers;
  late final List<FocusNode> _codeFocusNodes;

  bool _isLoading = false;
  String? _errorMessage;
  int _resendCountdown = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
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
      _handleVerify();
    } else {
      _codeFocusNodes[digits.length].requestFocus();
    }
  }

  Future<void> _handleVerify() async {
    final code = _codeControllers.map((c) => c.text.trim()).join();
    if (code.length != _codeLength) {
      setState(() => _errorMessage = 'Ingresá los 6 dígitos del código');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await widget.authService.verifyMfa(
        challengeId: widget.challengeId,
        code: code,
        rememberMe: widget.rememberMe,
      );

      if (mounted && response.success) {
        // Notificar al padre que el 2FA fue exitoso.
        // main.dart decide la siguiente pantalla (declarativo).
        // NO hacer Navigator.pop porque esta pantalla NO fue empujada por nosotros.
        widget.onMfaSuccess?.call();
      }
    } catch (e) {
      if (!mounted) return;
      final errorStr = e.toString();
      String errorMsg;
      if (errorStr.contains('MFA_CODE_EXPIRED')) {
        errorMsg = 'El código expiró. Solicitá uno nuevo.';
      } else if (errorStr.contains('MFA_TOO_MANY_ATTEMPTS')) {
        errorMsg = 'Demasiados intentos. Solicitá un nuevo código.';
      } else if (errorStr.contains('MFA_CODE_ALREADY_USED')) {
        errorMsg = 'Este código ya fue utilizado. Solicitá uno nuevo.';
      } else if (errorStr.contains('MFA_CHALLENGE_NOT_FOUND')) {
        errorMsg =
            'El desafío de seguridad no es válido. Volvé a iniciar sesión.';
      } else {
        errorMsg = 'Código incorrecto. Verificalo e intentá de nuevo.';
      }
      setState(() {
        _errorMessage = errorMsg;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleResend() async {
    if (_resendCountdown > 0 || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.authService.resendMfaCode(challengeId: widget.challengeId);
      if (mounted) {
        setState(() {
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
            content: Text('Nuevo código enviado a tu correo corporativo.'),
            backgroundColor: AppTheme.emeraldSuccess,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorStr = e.toString();
        setState(() {
          if (errorStr.contains('segundo')) {
            _errorMessage = 'Debes esperar antes de solicitar un nuevo código.';
          } else {
            _errorMessage = 'No pudimos reenviar el código. Intentá de nuevo.';
          }
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCodeInput(int index, bool isDark) {
    return SizedBox(
      width: 44,
      height: 54,
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
            fontSize: 22,
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
                    : const Color(0xFFE2E8F0),
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
                _handleVerify();
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

    final desktopBranding = AuthBrandingPanel(isDesktop: true, isDark: isDark);
    final mobileBranding = AuthBrandingPanel(isDesktop: false, isDark: isDark);

    final formContent = Container(
      width: isDesktop ? 480 : double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: isDesktop ? 44 : 32,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ícono Superior Escudo 2FA
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security_rounded,
                color: Color(0xFF1E3A8A),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Título
          Text(
            'Verificación de Dos Pasos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),

          // Subtítulo con Email Ofuscado
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF475569),
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text:
                      'Ingresá el código de 6 dígitos enviado a tu correo corporativo ',
                ),
                TextSpan(
                  text: widget.emailHint,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Banner de Error
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFDC2626),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFDC2626),
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

          // 6 Inputs OTP
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _codeLength,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: index == _codeLength - 1 ? 0 : 8,
                  ),
                  child: _buildCodeInput(index, isDark),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Link de Reenvío con Cuenta Regresiva
          Center(
            child: _resendCountdown > 0
                ? Text(
                    '¿No recibiste el código? Reenviar en ${_resendCountdown}s',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  )
                : TextButton(
                    onPressed: _isLoading ? null : _handleResend,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    child: const Text(
                      'Reenviar código',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 24),

          // Botón Verificar e Ingresar
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleVerify,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                elevation: 0,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verificar e ingresar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Link Volver al Inicio de Sesión
          Center(
            child: TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await widget.authService.logout();
                if (mounted && navigator.canPop()) {
                  navigator.pop(false);
                }
              },
              child: Text(
                'Volver al inicio de sesión',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 5, child: desktopBranding),
                Expanded(
                  flex: 7,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 48,
                      ),
                      child: formContent,
                    ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  mobileBranding,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: formContent,
                  ),
                ],
              ),
            ),
    );
  }
}
