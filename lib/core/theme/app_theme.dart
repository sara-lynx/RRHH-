import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de diseño visual y temas para Elite Multiservicios.
/// Diseñado con estándares de alta jerarquía visual, accesibilidad y tokens de Google Stitch.
abstract class AppTheme {
  // Paleta de Colores Primaria y Acentos (Tokens Stitch)
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Royal Blue
  static const Color primaryHover = Color(0xFF0F172A);
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color accentIndigo = Color(0xFF4F46E5);
  static const Color emeraldSuccess = Color(0xFF059669);
  static const Color amberWarning = Color(0xFFD97706);
  static const Color roseDanger = Color(0xFFE11D48);
  static const Color statusError = Color(0xFFEF4444);
  static const Color statusErrorBg = Color(0xFFFEF2F2);

  // Fondos y Superficies Modo Claro
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Fondos y Superficies Modo Oscuro
  static const Color darkBg = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkSurfaceElevated = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  /// Tema Claro
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentBlue,
        surface: lightSurface,
        error: statusError,
      ),
      scaffoldBackgroundColor: lightBg,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: lightBorder),
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: statusError),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: statusError, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: lightTextPrimary),
      ),
    );
  }

  /// Tema Oscuro
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: primaryBlue,
        surface: darkSurface,
        error: statusError,
      ),
      scaffoldBackgroundColor: darkBg,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F172A),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: accentBlue, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: statusError),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: statusError, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      scrollbarTheme: ScrollbarThemeData(
        interactive: true,
        radius: const Radius.circular(8),
        thickness: const WidgetStatePropertyAll(8),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return const Color(0xFF94A3B8);
          }
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFF64748B);
          }
          return const Color(0xFF475569);
        }),
      ),
    );
  }
}
