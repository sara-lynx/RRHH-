import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Estado Vacío para las vistas del módulo RRHH.
class RrhhEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const RrhhEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.analytics_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: const Color(0xFF64748B)),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF8FAFC),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Estado de Error con botón de reintento para las vistas del módulo RRHH.
class RrhhErrorState extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const RrhhErrorState({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: const Color(0xFF7F1D1D).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDC2626)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Color(0xFFEF4444)),
            const SizedBox(height: 12),
            Text(
              'Error al Cargar Información',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFECACA),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ??
                  'Ocurrió un error inesperado al conectar con el repositorio.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFFFCA5A5),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Reintentar Conexión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado 403 Forbidden para accesos denegados en vistas del módulo RRHH.
class RrhhForbiddenState extends StatelessWidget {
  final String requiredPermission;

  const RrhhForbiddenState({
    super.key,
    required this.requiredPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_person_outlined,
              size: 48,
              color: Color(0xFFF59E0B),
            ),
            const SizedBox(height: 16),
            Text(
              '403 - Acceso Denegado',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFF8FAFC),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No cuenta con los privilegios suficientes para consultar este módulo.\nRequiere $requiredPermission',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
