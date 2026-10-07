import 'package:flutter/material.dart';

import 'package:artplay_launcher/ui/theme/app_colors.dart';

/// Estilos de texto SIN color: heredan el color del panel donde se usan
/// (negro sobre crema/dorado, crema sobre negro). Si hace falta un color
/// concreto se usa `AppText.x.copyWith(color: ...)`.
abstract class AppText {
  /// Título grande de la pantalla de inicio.
  static const TextStyle display = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.05,
    letterSpacing: -0.6,
  );

  /// Cifras destacadas dentro de los paneles (jugadores, ping…).
  static const TextStyle metric = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -0.4,
  );

  /// Título de pantalla.
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  static const TextStyle titleL = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle titleM = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// Etiquetas en mayúsculas ("JUGADORES", "PING"…).
  static const TextStyle label = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 1.6,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );
}

abstract class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.gold,
      onPrimary: AppColors.ink,
      secondary: AppColors.cream,
      onSecondary: AppColors.ink,
      surface: AppColors.ink,
      onSurface: AppColors.cream,
      error: AppColors.offline,
      onError: AppColors.cream,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: 'Rubik',
    );

    final textTheme = base.textTheme
        .copyWith(
          displayMedium: AppText.display,
          headlineSmall: AppText.heading,
          titleLarge: AppText.titleL,
          titleMedium: AppText.titleM,
          bodyMedium: AppText.body,
          bodySmall: AppText.caption,
          labelSmall: AppText.label,
          labelLarge: AppText.button,
        )
        .apply(
          fontFamily: 'Rubik',
          displayColor: AppColors.cream,
          bodyColor: AppColors.cream,
        );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.inkDeep,
      textTheme: textTheme,
      // Estética Bauhaus: esquinas rectas en todo el sistema.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.ink,
          shape: const RoundedRectangleBorder(),
          textStyle: AppText.button,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cream,
        contentTextStyle: AppText.body.copyWith(color: AppColors.ink),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(),
        width: 360,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.gold,
        linearTrackColor: AppColors.inkLine,
      ),
    );
  }
}
