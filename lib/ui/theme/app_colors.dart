import 'package:flutter/material.dart';

/// Paleta de Valdoria RP: azul noche, borgoña y oro.
abstract class AppColors {
  // --- Colores de marca ---
  static const Color ink = Color(0xFF151B2B); // azul noche: paneles
  static const Color gold = Color(0xFFD5AD55); // oro: acentos y acciones
  static const Color cream = Color(0xFFF7F1E5); // marfil: texto y superficies claras
  static const Color burgundy = Color(0xFF7D2638); // borgoña: identidad y énfasis

  // --- Superficies ---
  static const Color inkDeep = Color(0xFF0D1220); // fondo principal
  static const Color inkRaised = Color(0xFF20283A); // panel secundario
  static const Color inkLine = Color(0xFF354056); // bordes y divisores

  // --- Texto secundario ---
  static const Color creamDim = Color(0xFFC4BEBA);
  static const Color inkMuted = Color(0xFF5B5360);

  // --- Estados ---
  static const Color online = Color(0xFF5FB982);
  static const Color offline = Color(0xFFE16A67);

  /// Color de contenido legible (azul noche o marfil) para un fondo dado.
  static Color on(Color background) =>
      background.computeLuminance() > 0.18 ? ink : cream;
}
