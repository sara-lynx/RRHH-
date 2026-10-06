import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Modelo de evaluación individual para cada regla de la política de contraseñas.
class PasswordRequirementItem {
  final String label;
  final bool isMet;

  const PasswordRequirementItem({
    required this.label,
    required this.isMet,
  });
}

/// Widget ejecutivo que muestra los requisitos de seguridad de contraseña
/// y el medidor dinámico de fortaleza en 4 segmentos, conforme al sistema Executive Precision.
class PasswordRequirementsWidget extends StatelessWidget {
  final String password;
  final String? email;
  final String? fullName;
  final bool isCompact;

  static const String _symbols = '!@#\$%^&*(),.?":{}|<>';

  static const Set<String> _commonPasswords = {
    '123456',
    'password',
    '12345678',
    'qwerty',
    '123456789',
    '12345',
    '1234',
    '111111',
    '1234567',
    'dragon',
    'welcome',
    'admin123',
    'admin',
    'root',
    'elitemultiservicios',
    'contraseña',
    'clave123',
    'password123',
    'secret',
    'master',
  };

  const PasswordRequirementsWidget({
    super.key,
    required this.password,
    this.email,
    this.fullName,
    this.isCompact = false,
  });

  bool get hasMinLength => password.length >= 10;
  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(password);
  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(password);
  bool get hasDigit => RegExp(r'[0-9]').hasMatch(password);
  bool get hasSymbol => password.split('').any((c) => _symbols.contains(c));

  bool get isNotCommon {
    final lower = password.trim().toLowerCase();
    if (lower.isEmpty) return false;
    if (_commonPasswords.contains(lower)) return false;
    if (email != null && email!.trim().isNotEmpty) {
      final emailPrefix = email!.trim().toLowerCase().split('@').first;
      if (emailPrefix.length >= 3 && lower.contains(emailPrefix)) return false;
    }
    if (fullName != null && fullName!.trim().isNotEmpty) {
      final words = fullName!.trim().toLowerCase().split(RegExp(r'\s+'));
      for (final w in words) {
        if (w.length >= 3 && lower.contains(w)) return false;
      }
    }
    return true;
  }

  List<PasswordRequirementItem> get requirements => [
    PasswordRequirementItem(
      label: 'Mínimo 10 caracteres',
      isMet: hasMinLength,
    ),
    PasswordRequirementItem(
      label: 'Al menos una letra mayúscula (A-Z)',
      isMet: hasUppercase,
    ),
    PasswordRequirementItem(
      label: 'Al menos una letra minúscula (a-z)',
      isMet: hasLowercase,
    ),
    PasswordRequirementItem(
      label: 'Al menos un número (0-9)',
      isMet: hasDigit,
    ),
    PasswordRequirementItem(
      label: 'Al menos un carácter especial (!@#\$%...)',
      isMet: hasSymbol,
    ),
    PasswordRequirementItem(
      label: 'No es una contraseña común ni predecible',
      isMet: isNotCommon,
    ),
  ];

  int get metCount => requirements.where((r) => r.isMet).length;

  int get strengthScore {
    if (password.isEmpty) return 0;
    int score = 0;
    if (hasMinLength) score++;
    if (hasUppercase && hasLowercase) score++;
    if (hasDigit && hasSymbol) score++;
    if (isNotCommon && password.length >= 12) score++;
    return score;
  }

  String get strengthLabel {
    final score = strengthScore;
    if (score <= 1) return 'Débil';
    if (score == 2) return 'Aceptable';
    if (score == 3) return 'Segura';
    return 'Óptima';
  }

  Color get strengthColor {
    final score = strengthScore;
    if (score <= 1) return const Color(0xFFEF4444);
    if (score == 2) return const Color(0xFFF59E0B);
    if (score == 3) return const Color(0xFF2563EB);
    return const Color(0xFF10B981);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final textPrimary = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Container(
      padding: EdgeInsets.all(isCompact ? 14 : 18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(50)
                : const Color(0xFF0F172A).withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header con escudo e indicador en tiempo real
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E3A8A).withAlpha(60)
                      : AppTheme.primaryBlue.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requisitos de Seguridad',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      'Verificación en tiempo real ($metCount/6)',
                      style: TextStyle(
                        fontSize: 12,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge de fortaleza
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: strengthColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: strengthColor.withAlpha(80)),
                ),
                child: Text(
                  strengthLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: strengthColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Medidor de fortaleza (4 barras)
          Row(
            children: List.generate(4, (index) {
              final active = index < strengthScore;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: active
                        ? strengthColor
                        : (isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 14),

          // Lista de los 6 criterios
          ...requirements.map((req) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.5),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: req.isMet
                          ? const Color(0xFF10B981)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: req.isMet
                            ? const Color(0xFF10B981)
                            : (isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8)),
                        width: 1.5,
                      ),
                    ),
                    child: req.isMet
                        ? const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      req.label,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: req.isMet
                            ? (isDark
                                  ? const Color(0xFFE2E8F0)
                                  : const Color(0xFF1E293B))
                            : textMuted,
                        fontWeight: req.isMet
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
