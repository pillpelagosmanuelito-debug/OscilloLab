import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema visual de OscilloLab.
///
/// Paleta deliberadamente distinta a las apps anteriores de la fabrica
/// (CircuitLab Academy usa azul/naranja de PCB; CircuitAR usa verde
/// esquematico): aqui se usa una paleta "panel de instrumento" —
/// verde fosforo de osciloscopio sobre grafito oscuro, con acento
/// ambar de multimetro de banco. Ademas la navegacion principal es una
/// barra inferior de 5 modulos en vez del Drawer lateral usado antes.
class AppTheme {
  static const Color grafito = Color(0xFF12181B);
  static const Color panel = Color(0xFF1B2427);
  static const Color verdeFosforo = Color(0xFF39FF88);
  static const Color ambarMultimetro = Color(0xFFFFB300);
  static const Color rojoAlerta = Color(0xFFFF5252);

  static ThemeData get tema {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: verdeFosforo,
      brightness: Brightness.dark,
      primary: verdeFosforo,
      secondary: ambarMultimetro,
      error: rojoAlerta,
      surface: panel,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: grafito,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: grafito,
        foregroundColor: verdeFosforo,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: panel,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: panel,
        indicatorColor: verdeFosforo.withOpacity(0.25),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: verdeFosforo,
          foregroundColor: grafito,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  /// Fuente monoespaciada usada solo en pantallas de instrumento
  /// (multimetro/osciloscopio), para imitar un display de 7 segmentos.
  static TextStyle get textoDisplay => GoogleFonts.jetBrainsMono(
        color: verdeFosforo,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );
}
