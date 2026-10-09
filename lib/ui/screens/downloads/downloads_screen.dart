import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:artplay_launcher/config/app_config.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_metrics.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/widgets/geo_tile.dart';
import 'package:artplay_launcher/ui/widgets/screen_header.dart';

/// Centro de descargas del cliente Android.
///
/// La descarga solo se habilita cuando AppConfig.clientApkUrl apunta a una
/// distribución HTTPS conocida. No se inventa ni se descarga un APK de origen
/// desconocido.
class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  Future<void> _openClientDownload(BuildContext context) async {
    final source = AppConfig.clientApkUrl;
    if (source == null || source.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('La fuente oficial del cliente todavía no está configurada.'),
          ),
        );
      return;
    }

    final uri = Uri.tryParse(source);
    if (uri == null || uri.scheme != 'https' || !await canLaunchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('No se pudo abrir la fuente de descarga.')),
        );
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final sourceConfigured = AppConfig.clientApkUrl != null &&
        AppConfig.clientApkUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(AppMetrics.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(
            eyebrow: 'CLIENTE ANDROID',
            title: 'Descargas',
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
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              color: AppColors.gold,
                              child: const Icon(
                                Icons.android_rounded,
                                color: AppColors.ink,
                                size: 29,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GOLDEN UNDERWORLD',
                                    style: AppText.label.copyWith(color: AppColors.gold),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text('Cliente SA-MP para Android', style: AppText.titleL),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(height: 1, color: AppColors.inkLine),
                        const SizedBox(height: 20),
                        Text(
                          sourceConfigured ? 'FUENTE DISPONIBLE' : 'DESCARGA EN PREPARACIÓN',
                          style: AppText.label.copyWith(
                            color: sourceConfigured ? AppColors.online : AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          sourceConfigured
                              ? 'La fuente del cliente está configurada. Abre la descarga para continuar con el instalador de Android.'
                              : 'Aquí estará el instalador del cliente necesario para entrar al servidor. Estamos preparando la fuente de distribución antes de habilitar la descarga.',
                          style: AppText.body.copyWith(color: AppColors.creamDim, height: 1.6),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _openClientDownload(context),
                            icon: Icon(sourceConfigured
                                ? Icons.download_rounded
                                : Icons.hourglass_top_rounded),
                            label: Text(sourceConfigured ? 'ABRIR DESCARGA' : 'DESCARGA NO DISPONIBLE'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sourceConfigured
                              ? 'La instalación final puede requerir autorización de Android.'
                              : 'No se descargará ningún archivo hasta verificar el enlace del APK.',
                          style: AppText.caption.copyWith(color: AppColors.creamDim),
                          textAlign: TextAlign.center,
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
                              Text('INSTALACIÓN', style: AppText.label),
                              const SizedBox(height: 14),
                              const _StepLine(
                                number: '01',
                                title: 'Descargar',
                                detail: 'Obtener el APK desde una fuente verificada.',
                              ),
                              const SizedBox(height: 16),
                              const _StepLine(
                                number: '02',
                                title: 'Instalar',
                                detail: 'Android solicitará autorización si es necesaria.',
                              ),
                              const SizedBox(height: 16),
                              const _StepLine(
                                number: '03',
                                title: 'Conectar',
                                detail: 'Volver al launcher para entrar al servidor.',
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
                                'VERIFICACIÓN',
                                style: AppText.label.copyWith(color: AppColors.gold),
                              ),
                              const SizedBox(height: 10),
                              const _IntegrityRow(
                                title: 'Origen del APK',
                                value: sourceConfigured ? 'Configurado' : 'Pendiente',
                              ),
                              const SizedBox(height: 8),
                              const _IntegrityRow(
                                title: 'Hash SHA-256',
                                value: 'Por configurar',
                              ),
                              const SizedBox(height: 8),
                              const _IntegrityRow(
                                title: 'Instalación silenciosa',
                                value: 'No permitida',
                              ),
                              const Spacer(),
                              Text(
                                'La verificación de integridad se incorporará antes de publicar el cliente.',
                                style: AppText.caption.copyWith(color: AppColors.creamDim),
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

class _StepLine extends StatelessWidget {
  const _StepLine({
    required this.number,
    required this.title,
    required this.detail,
  });

  final String number;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number, style: AppText.titleM.copyWith(color: AppColors.inkMuted)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.titleM),
              const SizedBox(height: 3),
              Text(detail, style: AppText.body.copyWith(color: AppColors.inkMuted)),
            ],
          ),
        ),
      ],
    );
  }
}

class _IntegrityRow extends StatelessWidget {
  const _IntegrityRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: AppText.body.copyWith(color: AppColors.creamDim)),
        ),
        const SizedBox(width: 8),
        Text(value, style: AppText.caption.copyWith(color: AppColors.cream)),
      ],
    );
  }
}
