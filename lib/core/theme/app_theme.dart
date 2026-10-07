import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de diseño visual y temas para Elite Multiservicios.
/// Configurado al 100% en MODO CLARO ESTRICTO corporativo (Esmeralda #0D9488 y Slate).
abstract class AppTheme {
  // Paleta de Colores Corporativa Elite (Esmeralda y Slate)
  static const Color primaryEmerald = Color(0xFF0D9488);
  static const Color primaryEmeraldDark = Color(0xFF0F766E);
  static const Color primaryHover = Color(0xFF115E59);
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color emeraldSuccess = Color(0xFF059669);
  static const Color statusSuccess = Color(0xFF047857);
  static const Color statusWarning = Color(0xFFB45309);
  static const Color statusError = Color(0xFFB91C1C);
  static const Color statusErrorBg = Color(0xFFFEF2F2);

  // Fondos y Superficies Modo Claro
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  /// Tema 100% Modo Claro Estricto Blindado contra Fondos Oscuros
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      canvasColor: Colors.white, // OBLIGATORIO: Evita dropdowns negros nativos
      cardColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0D9488), // Verde esmeralda corporativo
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: Color(0xFF0F172A),
        error: Color(0xFFB91C1C),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        textStyle: TextStyle(color: Color(0xFF0F172A), fontSize: 13),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        labelStyle: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        interactive: true,
        radius: const Radius.circular(8),
        thickness: const WidgetStatePropertyAll(8),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return const Color(0xFF64748B);
          }
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFF94A3B8);
          }
          return const Color(0xFFCBD5E1);
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF0D9488),
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: Color(0xFF0F172A)),
      ),
    );
  }

  /// Prohíbe cualquier fallback a modo oscuro devolviendo siempre el tema claro blindado
  static ThemeData get darkTheme => lightTheme;
}
