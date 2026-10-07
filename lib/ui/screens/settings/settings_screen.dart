import 'package:flutter/material.dart';

import 'package:artplay_launcher/config/app_config.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_metrics.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/widgets/geo_shapes.dart';
import 'package:artplay_launcher/ui/widgets/geo_tile.dart';
import 'package:artplay_launcher/ui/widgets/screen_header.dart';

/// Ajustes (por ahora solo estructura: aquí irán nombre de jugador, ruta del
/// juego, etc. cuando se defina qué debe poder configurar el usuario).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppMetrics.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(eyebrow: 'LAUNCHER', title: 'Ajustes'),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GeoTile(
                    color: AppColors.ink,
                    padding: const EdgeInsets.all(20),
                    decorations: const [
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 70,
                        height: 140,
                        child: CustomPaint(
                          painter: StripesPainter(
                            color: AppColors.gold,
                            count: 7,
                            vertical: true,
                            thickness: 0.45,
                          ),
                        ),
                      ),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'PRÓXIMAMENTE',
                          style: AppText.label.copyWith(color: AppColors.gold),
                        ),
                        const SizedBox(height: 6),
                        const Text('Nombre de jugador', style: AppText.titleM),
                        const Text('Ruta de archivos del juego',
                            style: AppText.titleM),
                        const Text('Calidad y rendimiento', style: AppText.titleM),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GeoTile(
                    color: AppColors.cream,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('VERSIÓN', style: AppText.label),
                        const SizedBox(height: 4),
                        Text(AppConfig.appVersion, style: AppText.metric),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
