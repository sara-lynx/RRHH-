import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Botón de acción principal estandarizado para todo el módulo RRHH.
/// Renderiza un icono (por defecto `Icons.add`) y un label en texto claro,
/// evitando duplicaciones del símbolo "+" y manteniendo tipografía y padding homogéneos.
class RrhhPrimaryActionButton extends StatelessWidget {
  final String label; // SIN el "+" al inicio
  final VoidCallback? onPressed;
  final IconData icon; // default: Icons.add
  final bool enabled;

  const RrhhPrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
