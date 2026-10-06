import 'package:flutter/material.dart';

/// Panel de branding corporativo reutilizable para todas las pantallas de autenticación.
/// Garantiza consistencia visual (gradiente, logo, slogan, badges) sin duplicación de código.
class AuthBrandingPanel extends StatelessWidget {
  final bool isDesktop;
  final bool isDark;

  const AuthBrandingPanel({
    super.key,
    this.isDesktop = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return _buildMobileBranding();
    }
    return _buildDesktopBranding();
  }

  Widget _buildDesktopBranding() {
    return Container(
      width: 480,
      padding: const EdgeInsets.all(48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B0F19),
            Color(0xFF1E293B),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Semantics(
            header: true,
            child: const Text(
              'ELITE MULTISERVICIOS',
              style: TextStyle(
                fontSize: 0,
                height: 0,
                color: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'ENTRE TODOS ES MEJOR',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 4,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Plataforma empresarial de\nadministración',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Gestión centralizada, seguridad biométrica y cumplimiento operativo de nivel empresarial para todas tus sedes.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildBadge(
                Icons.verified_user_outlined,
                'ISO 27001 Certificada',
              ),
              _buildBadge(Icons.lock_outline, 'TLS 1.3'),
            ],
          ),
          const Spacer(),
          Text(
            '© 2026 Elite Multiservicios',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBranding() {
    return Column(
      children: [
        Image.asset('assets/images/logo.png', width: 130, fit: BoxFit.contain),
        const SizedBox(height: 8),
        Semantics(
          header: true,
          child: const Text(
            'ELITE MULTISERVICIOS',
            style: TextStyle(
              fontSize: 0,
              height: 0,
              color: Colors.transparent,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'ENTRE TODOS ES MEJOR',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 3.5,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF2563EB).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF60A5FA)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
