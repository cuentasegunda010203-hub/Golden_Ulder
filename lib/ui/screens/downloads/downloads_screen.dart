import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:artplay_launcher/config/app_config.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_metrics.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/widgets/geo_tile.dart';
import 'package:artplay_launcher/ui/widgets/screen_header.dart';

/// Asistente de preparación. No descarga ni redistribuye archivos propietarios
/// del juego; abre fuentes externas y deja claro qué pasos requieren al usuario.
class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  bool _gameInstalled = false;
  bool _clientInstalled = false;
  bool _resourcesReady = false;
  bool _busy = false;

  static final Uri _gameStore = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.rockstargames.gtasa',
  );
  static final Uri _clientSource = Uri.parse(
    'https://github.com/east9-777/Nativo_ApkSamp',
  );

  Future<void> _open(Uri uri, String label) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) _message('No se pudo abrir $label. Comprueba tu conexión.');
    } catch (_) {
      if (mounted) _message('No se pudo abrir $label. Comprueba tu conexión.');
    }
  }

  Future<void> _tryPlay() async {
    setState(() => _busy = true);
    final uri = Uri(scheme: 'samp', host: AppConfig.serverHost, port: AppConfig.serverPort);
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (!opened) {
      _message('No encontramos una aplicación compatible con samp://. Instala y configura un cliente SA-MP Android compatible primero.');
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _gameInstalled && _clientInstalled && _resourcesReady;
    return Padding(
      padding: const EdgeInsets.all(AppMetrics.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(
            eyebrow: 'GOLDEN UNDERWORLD RP',
            title: 'Instalación del juego',
          ),
          const SizedBox(height: 12),
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
                          child: const Icon(Icons.install_mobile_rounded, color: AppColors.ink, size: 28),
                        ),
                        const SizedBox(height: 18),
                        Text('PREPARA TU CLIENTE', style: AppText.label.copyWith(color: AppColors.gold)),
                        const SizedBox(height: 8),
                        const Text('Tres pasos antes de entrar a jugar.', style: AppText.titleL),
                        const SizedBox(height: 8),
                        Text(
                          'Marca cada paso cuando lo termines. Android puede requerir que confirmes las instalaciones externas. Este asistente no instala archivos silenciosamente ni incluye copias del juego.',
                          style: AppText.body.copyWith(color: AppColors.creamDim, height: 1.5),
                        ),
                        const SizedBox(height: 18),
                        _InstallStep(
                          number: '01',
                          title: 'GTA: San Andreas',
                          detail: 'Instala el juego compatible desde una fuente legítima y comprueba que abra.',
                          checked: _gameInstalled,
                          onChanged: (v) => setState(() => _gameInstalled = v),
                          actionLabel: 'ABRIR GOOGLE PLAY',
                          onAction: () => _open(_gameStore, 'Google Play'),
                        ),
                        const SizedBox(height: 12),
                        _InstallStep(
                          number: '02',
                          title: 'Cliente SA-MP Android',
                          detail: 'Instala un cliente compatible con tu versión y arquitectura de Android.',
                          checked: _clientInstalled,
                          onChanged: (v) => setState(() => _clientInstalled = v),
                          actionLabel: 'VER CÓDIGO DEL CLIENTE',
                          onAction: () => _open(_clientSource, 'la fuente del cliente'),
                        ),
                        const SizedBox(height: 12),
                        _InstallStep(
                          number: '03',
                          title: 'Datos y recursos',
                          detail: 'Abre el cliente una vez y sigue sus instrucciones para detectar/preparar los datos del juego. Marca esto cuando termine.',
                          checked: _resourcesReady,
                          onChanged: (v) => setState(() => _resourcesReady = v),
                        ),
                        const Spacer(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.inkLine)),
                          child: Row(
                            children: [
                              Icon(ready ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                                color: AppColors.gold),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ready ? 'Pasos marcados. Prueba la conexión al servidor.' : 'Los checks son manuales: Android no permite que esta pantalla confirme por sí sola los archivos internos del juego.',
                                  style: AppText.caption.copyWith(color: AppColors.creamDim),
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
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TU SERVIDOR', style: AppText.label),
                              const SizedBox(height: 12),
                              const Icon(Icons.dns_rounded, size: 30, color: AppColors.ink),
                              const SizedBox(height: 8),
                              Text(AppConfig.serverName, style: AppText.titleL.copyWith(color: AppColors.ink)),
                              const SizedBox(height: 6),
                              SelectableText(AppConfig.address, style: AppText.body.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700)),
                              const Spacer(),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: _busy ? null : _tryPlay,
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  label: Text(_busy ? 'ABRIENDO…' : 'PROBAR JUGAR'),
                                ),
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
                              Text('IMPORTANTE', style: AppText.label.copyWith(color: AppColors.gold)),
                              const SizedBox(height: 10),
                              Text(
                                'El código fuente del cliente no es un instalador APK listo para usar. Antes de distribuirlo, hay que verificar su licencia, compilarlo y probarlo en un teléfono real. No hay una descarga automática de datos configurada porque todavía no existe una fuente autorizada y comprobada para esos archivos.',
                                style: AppText.body.copyWith(color: AppColors.creamDim, height: 1.45),
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

class _InstallStep extends StatelessWidget {
  const _InstallStep({
    required this.number,
    required this.title,
    required this.detail,
    required this.checked,
    required this.onChanged,
    this.actionLabel,
    this.onAction,
  });

  final String number;
  final String title;
  final String detail;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inkLine),
        color: AppColors.inkRaised,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: AppText.label.copyWith(color: AppColors.gold)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.body.copyWith(color: AppColors.cream, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(detail, style: AppText.caption.copyWith(color: AppColors.creamDim, height: 1.4)),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: AppColors.gold),
                    child: Text(actionLabel!, style: AppText.label),
                  ),
                ],
              ],
            ),
          ),
          Checkbox(
            value: checked,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: AppColors.gold,
            checkColor: AppColors.ink,
          ),
        ],
      ),
    );
  }
}
