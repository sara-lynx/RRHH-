import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Vista temporal para pantallas en construcción del Módulo RRHH.
/// Cumple con la identidad visual de DESIGN.md (Canvas #0B0F19, Contenedores #0F172A).
class RrhhPlaceholderView extends StatelessWidget {
  final String title;
  final String blockName;
  final String description;
  final IconData icon;

  const RrhhPlaceholderView({
    super.key,
    required this.title,
    required this.blockName,
    required this.description,
    this.icon = Icons.construction_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0F19)
          : const Color(0xFFF8FAFC),
      body: Center(
        child: Container(
          constraints: const Duration(milliseconds: 300) == Duration.zero
              ? null
              : const BoxConstraints(maxWidth: 580),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'EN CONSTRUCCIÓN — $blockName',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Esta interfaz será implementada y conectada en su bloque correspondiente '
                'según la especificación de RRHH_WIREFRAMES.md.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontStyle: FontStyle.italic,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
