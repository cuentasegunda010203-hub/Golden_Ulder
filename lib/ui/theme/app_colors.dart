import 'package:flutter/material.dart';

/// Paleta del launcher, tomada de la plantilla geométrica (negro / dorado / crema).
///
/// Regla de uso: 3 colores de marca + 1 neutro para texto secundario.
/// Nada de colores sueltos (`Color(0xFF...)`) dentro de los widgets.
abstract class AppColors {
  // --- Marca ---
  static const Color ink = Color(0xFF231F20); // negro cálido (paneles)
  static const Color gold = Color(0xFFBB8F0A); // dorado/mostaza (acción principal)
  static const Color cream = Color(0xFFFCF9F2); // crema (texto y paneles claros)

  // --- Superficies derivadas del negro ---
  static const Color inkDeep = Color(0xFF181516); // fondo de la app
  static const Color inkRaised = Color(0xFF2F2A2B); // panel secundario
  static const Color inkLine = Color(0xFF3D3738); // bordes / pistas

  // --- Texto secundario ---
  static const Color creamDim = Color(0xFFB9B3AA); // sobre negro  (contraste ≈ 7:1)
  static const Color inkMuted = Color(0xFF6B6465); // sobre crema  (contraste ≈ 5:1)

  // --- Estados (solo para puntos/indicadores pequeños) ---
  static const Color online = Color(0xFF5FB36A);
  static const Color offline = Color(0xFFD65C4F);

  /// Color de contenido legible (negro o crema) para un fondo dado.
  static Color on(Color background) =>
      background.computeLuminance() > 0.18 ? ink : cream;
}
