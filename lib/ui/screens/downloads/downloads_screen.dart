import 'package:flutter/material.dart';

import 'package:artplay_launcher/config/app_config.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_metrics.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/widgets/geo_tile.dart';
import 'package:artplay_launcher/ui/widgets/screen_header.dart';

/// Centro de recursos del servidor.
/// El cliente SA-MP se configura por separado; aquí se publicarán recursos
/// propios cuando exista un paquete real y compatible que distribuir.
class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppMetrics.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(
            eyebrow: 'GOLDEN UNDERWORLD RP',
            title: 'Centro de recursos',
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 6,
                  child: GeoTile(
                    color: AppColors.ink,
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          color: AppColors.gold,
                          child: const Icon(
                            Icons.inventory_2_rounded,
                            color: AppColors.ink,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'RECURSOS OFICIALES',
                          style: AppText.label.copyWith(color: AppColors.gold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Un solo lugar para preparar la experiencia Golden Underworld.',
                          style: AppText.titleL,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'La prioridad actual es conectar el launcher con tu servidor SA-MP ya existente. Este apartado quedará preparado para publicar recursos compatibles cuando empecemos con los vehículos y las texturas.',
                          style: AppText.body.copyWith(
                            color: AppColors.creamDim,
                            height: 1.6,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.inkLine),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.dns_rounded,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('SERVIDOR CONFIGURADO', style: AppText.label),
                                    const SizedBox(height: 4),
                                    SelectableText(
                                      AppConfig.address,
                                      style: AppText.body.copyWith(
                                        color: AppColors.cream,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Expanded(
                        child: GeoTile(
                          color: AppColors.cream,
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SIGUIENTES PAQUETES', style: AppText.label),
                              const SizedBox(height: 16),
                              const _ResourceLine(
                                icon: Icons.directions_car_rounded,
                                title: 'Vehículos',
                                detail: 'Modelos y texturas compatibles.',
                              ),
                              const SizedBox(height: 16),
                              const _ResourceLine(
                                icon: Icons.texture_rounded,
                                title: 'Texturas y mapas',
                                detail: 'Contenido visual versionado.',
                              ),
                              const SizedBox(height: 16),
                              const _ResourceLine(
                                icon: Icons.verified_user_rounded,
                                title: 'Integridad',
                                detail: 'Versiones y hashes verificables.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: GeoTile(
                          color: AppColors.inkRaised,
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IMPORTANTE',
                                style: AppText.label.copyWith(color: AppColors.gold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'El launcher no incluye ni reemplaza el cliente SA-MP. Para jugar, necesitas tener un cliente compatible instalado; el botón JUGAR intentará abrirlo mediante un enlace de servidor.',
                                style: AppText.body.copyWith(
                                  color: AppColors.creamDim,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _ResourceLine extends StatelessWidget {
  const _ResourceLine({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppColors.ink),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.body.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(
                detail,
                style: AppText.caption.copyWith(color: AppColors.inkMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
