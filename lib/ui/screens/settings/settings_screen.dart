import 'package:flutter/material.dart';

import 'package:artplay_launcher/config/app_config.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_metrics.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/widgets/screen_header.dart';

/// Ajustes visualmente completos y adaptables; las preferencias avanzadas
/// se habilitarán cuando exista la integración con el cliente de juego.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppMetrics.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScreenHeader(eyebrow: 'VALDORIA RP', title: 'Ajustes'),
          const SizedBox(height: 18),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const _PreferencesPanel(),
                        const SizedBox(height: 12),
                        const SizedBox(height: 220, child: _BrandPanel()),
                      ],
                    ),
                  );
                }

                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 7, child: _PreferencesPanel()),
                    SizedBox(width: 14),
                    Expanded(flex: 3, child: _BrandPanel()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferencesPanel extends StatelessWidget {
  const _PreferencesPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inkLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.burgundy.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.settings_rounded, color: AppColors.gold),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Preferencias del launcher', style: AppText.titleL),
                    const SizedBox(height: 3),
                    Text(
                      'Personaliza tu experiencia de juego.',
                      style: AppText.body.copyWith(color: AppColors.creamDim),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          const _PreferenceRow(
            icon: Icons.person_outline_rounded,
            title: 'Nombre de jugador',
            subtitle: 'Se podrá configurar antes de entrar al servidor.',
          ),
          const SizedBox(height: 18),
          const _PreferenceRow(
            icon: Icons.folder_open_rounded,
            title: 'Archivos del juego',
            subtitle: 'Ubicación e instalación de los recursos del cliente.',
          ),
          const SizedBox(height: 18),
          const _PreferenceRow(
            icon: Icons.tune_rounded,
            title: 'Rendimiento',
            subtitle: 'Opciones de calidad y compatibilidad.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.inkRaised,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.inkLine.withValues(alpha: 0.7)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.gold, size: 17),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Estas opciones estarán disponibles en una próxima actualización.',
                    style: AppText.caption.copyWith(color: AppColors.creamDim),
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

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.burgundy,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.burgundy, Color(0xFF4B1A2A)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.shield_rounded, color: AppColors.gold, size: 42),
          const SizedBox(height: 12),
          Text(
            'VALDORIA RP',
            style: AppText.titleL.copyWith(
              color: AppColors.cream,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Una nueva historia te espera en San Andreas.',
            style: AppText.body.copyWith(color: AppColors.creamDim, height: 1.5),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: AppColors.gold.withValues(alpha: 0.45)),
          const SizedBox(height: 12),
          Text(
            'VERSIÓN DEL LAUNCHER',
            style: AppText.label.copyWith(
              color: AppColors.creamDim,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            AppConfig.appVersion,
            style: AppText.metric.copyWith(color: AppColors.cream),
          ),
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 21, color: AppColors.gold),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.titleM),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppText.caption.copyWith(color: AppColors.creamDim),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'PRÓXIMAMENTE',
          style: AppText.label.copyWith(
            color: AppColors.creamDim,
            fontSize: 8,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
