import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:artplay_launcher/config/app_config.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_metrics.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/widgets/geo_shapes.dart';
import 'package:artplay_launcher/ui/widgets/geo_tile.dart';
import 'package:artplay_launcher/ui/widgets/screen_header.dart';

/// Preferencias locales listas para conectarse posteriormente con el cliente
/// SA-MP. Las opciones de gráficos son preferencias de interfaz, no cambian
/// todavía el rendimiento del juego ni instalan/configuran el cliente.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _nicknameKey = 'launcher_nickname';
  static const _qualityKey = 'launcher_ui_quality';
  static const _animationsKey = 'launcher_animations';

  final _nicknameController = TextEditingController();
  String _quality = 'Equilibrado';
  bool _animations = true;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _nicknameController.text = prefs.getString(_nicknameKey) ?? '';
      _quality = prefs.getString(_qualityKey) ?? 'Equilibrado';
      _animations = prefs.getBool(_animationsKey) ?? true;
      _loading = false;
    });
  }

  Future<void> _savePreferences() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.length > 24) {
      _notice('El nombre no puede superar los 24 caracteres.');
      return;
    }

    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_nicknameKey, nickname);
      await prefs.setString(_qualityKey, _quality);
      await prefs.setBool(_animationsKey, _animations);
      if (mounted) _notice('Preferencias guardadas en este dispositivo.');
    } catch (_) {
      if (mounted) _notice('No se pudieron guardar los ajustes. Inténtalo otra vez.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _notice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppMetrics.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(
            eyebrow: 'PERSONALIZACIÓN',
            title: 'Ajustes',
            trailing: FilledButton.icon(
              onPressed: _loading || _saving ? null : _savePreferences,
              icon: _saving
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded, size: 18),
              label: Text(_saving ? 'GUARDANDO' : 'GUARDAR'),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 6,
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
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PERFIL DE JUEGO',
                                    style: AppText.label.copyWith(color: AppColors.gold)),
                                const SizedBox(height: 7),
                                const Text('Tu identidad', style: AppText.titleL),
                                const SizedBox(height: 5),
                                Text(
                                  'Guarda el nombre que quieres usar al entrar. Se conectará con el cliente cuando implementemos el lanzamiento real.',
                                  style: AppText.body.copyWith(color: AppColors.creamDim),
                                ),
                                const SizedBox(height: 18),
                                const Text('NOMBRE DE JUGADOR', style: AppText.label),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _nicknameController,
                                  maxLength: 24,
                                  textCapitalization: TextCapitalization.none,
                                  decoration: const InputDecoration(
                                    hintText: 'Ej. Juan_Mendoza',
                                    prefixIcon: Icon(Icons.person_outline_rounded),
                                    counterText: '',
                                  ),
                                ),
                                const SizedBox(height: 18),
                                const Divider(color: AppColors.inkLine),
                                const SizedBox(height: 10),
                                Text('PREFERENCIAS DE INTERFAZ',
                                    style: AppText.label.copyWith(color: AppColors.gold)),
                                SwitchListTile.adaptive(
                                  contentPadding: EdgeInsets.zero,
                                  value: _animations,
                                  activeColor: AppColors.gold,
                                  title: const Text('Animaciones'),
                                  subtitle: Text(
                                    'Preferir transiciones de pantalla',
                                    style: AppText.caption.copyWith(color: AppColors.creamDim),
                                  ),
                                  onChanged: (value) => setState(() => _animations = value),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: GeoTile(
                                color: AppColors.cream,
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('PRESENTACIÓN', style: AppText.label),
                                    const SizedBox(height: 8),
                                    const Text('Nivel visual', style: AppText.titleL),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Preferencia preparada para futuras opciones gráficas.',
                                      style: AppText.body.copyWith(color: AppColors.inkMuted),
                                    ),
                                    const SizedBox(height: 14),
                                    ...['Ahorro', 'Equilibrado', 'Detallado'].map(
                                      (option) => Padding(
                                        padding: const EdgeInsets.only(bottom: 6),
                                        child: InkWell(
                                          onTap: () => setState(() => _quality = option),
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 160),
                                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: _quality == option ? AppColors.gold : Colors.transparent,
                                              border: Border.all(
                                                color: _quality == option ? AppColors.gold : AppColors.inkMuted.withValues(alpha: 0.35),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  _quality == option ? Icons.radio_button_checked : Icons.radio_button_off,
                                                  size: 17,
                                                  color: AppColors.ink,
                                                ),
                                                const SizedBox(width: 9),
                                                Text(option, style: AppText.body.copyWith(fontWeight: _quality == option ? FontWeight.w700 : FontWeight.w400)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              flex: 3,
                              child: GeoTile(
                                color: AppColors.inkRaised,
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('VERSIÓN DEL LAUNCHER',
                                        style: AppText.label.copyWith(color: AppColors.gold)),
                                    Text(AppConfig.appVersion, style: AppText.metric.copyWith(color: AppColors.cream)),
                                    Text('Golden Underworld RP · Android',
                                        style: AppText.caption.copyWith(color: AppColors.creamDim)),
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
