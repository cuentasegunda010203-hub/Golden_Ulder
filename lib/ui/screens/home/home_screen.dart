import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:artplay_launcher/bloc/server/server_bloc.dart';
import 'package:artplay_launcher/config/app_config.dart';
import 'package:artplay_launcher/entities/server.dart';
import 'package:artplay_launcher/state/server_state_event.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_metrics.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/utils/actions.dart';
import 'package:artplay_launcher/ui/widgets/geo_shapes.dart';
import 'package:artplay_launcher/ui/widgets/geo_tile.dart';
import 'package:artplay_launcher/ui/widgets/status_chip.dart';

/// Pantalla de inicio: mosaico de paneles (estilo plantilla geométrica).
///
/// ```
/// ┌──────────────── hero ───────────────┬──── JUGAR ────┐
/// │ nombre · estado · IP                │               │
/// ├──────────┬──────────┬───────────────┼───────┬───────┤
/// │ jugadores│   ping   │     modo      │discord│  web  │
/// └──────────┴──────────┴───────────────┴───────┴───────┘
/// ```
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ServerBloc>();

    return StreamBuilder<ServerState>(
      stream: bloc.stateStream,
      initialData: bloc.currentState,
      builder: (context, snapshot) {
        final state = snapshot.data ?? bloc.currentState;
        final info = state.primary;

        return Padding(
          padding: const EdgeInsets.all(AppMetrics.page),
          child: Row(
            children: [
              // Columna izquierda: hero + métricas
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(flex: 5, child: _HeroTile(status: state.status)),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(child: _PlayersTile(info: info)),
                          Expanded(child: _PingTile(info: info)),
                          Expanded(child: _ModeTile(info: info)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Columna derecha: acción principal + redes
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const Expanded(flex: 5, child: _PlayTile()),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: const [
                          Expanded(
                            child: _SocialTile(
                              icon: Icons.forum_rounded,
                              label: 'Discord',
                              color: AppColors.inkRaised,
                              url: AppConfig.discordUrl,
                            ),
                          ),
                          Expanded(
                            child: _SocialTile(
                              icon: Icons.language_rounded,
                              label: 'Web',
                              color: AppColors.cream,
                              url: AppConfig.websiteUrl,
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
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Paneles
// ---------------------------------------------------------------------------

class _HeroTile extends StatelessWidget {
  const _HeroTile({required this.status});

  final ServerStatus status;

  @override
  Widget build(BuildContext context) {
    return GeoTile(
      color: AppColors.ink,
      padding: const EdgeInsets.all(20),
      decorations: const [
        // Semicírculo dorado colgando del borde superior derecho.
        Positioned(
          top: 0,
          right: 28,
          width: 76,
          height: 38,
          child: CustomPaint(
            painter: HalfDiscPainter(
              color: AppColors.gold,
              facing: HalfFacing.down,
            ),
          ),
        ),
        // Asterisco en la esquina inferior derecha.
        Positioned(
          right: 22,
          bottom: 22,
          width: 46,
          height: 46,
          child: CustomPaint(
            painter: AsteriskPainter(color: AppColors.cream, strokeWidth: 3),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SA-MP · ROLEPLAY',
                style: AppText.label.copyWith(color: AppColors.gold),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: '${AppConfig.serverName} '),
                      TextSpan(
                        text: AppConfig.serverSuffix,
                        style: const TextStyle(color: AppColors.gold),
                      ),
                    ],
                  ),
                  style: AppText.display,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppConfig.tagline,
                style: AppText.body.copyWith(color: AppColors.creamDim),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          // Wrap: si la pantalla es estrecha, los chips pasan a otra línea
          // en vez de desbordar.
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              StatusChip(status: status),
              const _AddressChip(),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressChip extends StatelessWidget {
  const _AddressChip();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => copyText(
        context,
        AppConfig.address,
        message: 'Dirección copiada',
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cream.withValues(alpha: 0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.dns_rounded, size: 14, color: AppColors.gold),
            const SizedBox(width: 8),
            Text(AppConfig.address, style: AppText.caption),
            const SizedBox(width: 8),
            const Icon(
              Icons.content_copy_rounded,
              size: 13,
              color: AppColors.creamDim,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayTile extends StatelessWidget {
  const _PlayTile();

  @override
  Widget build(BuildContext context) {
    return GeoTile(
      color: AppColors.gold,
      padding: const EdgeInsets.all(18),
      semanticLabel: 'Jugar',
      // TODO: aquí va la lógica real (verificar archivos del juego, descargar
      // si faltan y lanzar SA-MP con el nombre de jugador y el servidor).
      onTap: () => showAppSnack(context, 'Lanzamiento del juego pendiente'),
      decorations: const [
        Positioned(
          top: -34,
          right: -34,
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: ConcentricPainter(
              color: AppColors.ink,
              rings: 3,
              strokeWidth: 5,
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 44,
            height: 44,
            color: AppColors.ink,
            child: const Icon(
              Icons.play_arrow_rounded,
              size: 30,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'JUGAR',
              style: AppText.display.copyWith(letterSpacing: 1.5),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Conectar al servidor',
            style: AppText.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PlayersTile extends StatelessWidget {
  const _PlayersTile({required this.info});

  final ServerInfo? info;

  @override
  Widget build(BuildContext context) {
    final data = info;

    return GeoTile(
      color: AppColors.cream,
      semanticLabel: data == null
          ? 'Jugadores: sin datos'
          : 'Jugadores: ${data.players} de ${data.maxPlayers}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('JUGADORES', style: AppText.label),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: data == null
                      ? const Text('—', style: AppText.metric)
                      : Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${data.players}',
                                style: AppText.metric,
                              ),
                              TextSpan(
                                text: ' / ${data.maxPlayers}',
                                style: AppText.body.copyWith(
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                        ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox.square(
                dimension: 40,
                child: CustomPaint(
                  painter: RingGaugePainter(
                    value: data?.fill ?? 0,
                    color: AppColors.gold,
                    trackColor: AppColors.ink.withValues(alpha: 0.12),
                    strokeWidth: 7,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PingTile extends StatelessWidget {
  const _PingTile({required this.info});

  final ServerInfo? info;

  @override
  Widget build(BuildContext context) {
    final ping = info?.pingMs;

    return GeoTile(
      color: AppColors.inkRaised,
      semanticLabel: ping == null ? 'Ping: sin datos' : 'Ping: $ping milisegundos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('PING', style: AppText.label),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: ping == null
                      ? const Text('—', style: AppText.metric)
                      : Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$ping',
                                style: AppText.metric.copyWith(
                                  color: AppColors.gold,
                                ),
                              ),
                              TextSpan(
                                text: ' ms',
                                style: AppText.body.copyWith(
                                  color: AppColors.creamDim,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                        ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 30,
                height: 26,
                child: CustomPaint(
                  painter: SignalBarsPainter(
                    level: info?.signalLevel ?? 0,
                    activeColor: AppColors.gold,
                    inactiveColor: AppColors.inkLine,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({required this.info});

  final ServerInfo? info;

  @override
  Widget build(BuildContext context) {
    final data = info;
    final language = data?.language ?? '';

    return GeoTile(
      color: AppColors.gold,
      decorations: [
        Positioned(
          top: 12,
          right: 12,
          width: 26,
          height: 26,
          child: CustomPaint(
            painter: AsteriskPainter(
              color: AppColors.ink.withValues(alpha: 0.55),
              strokeWidth: 2.5,
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('MODO', style: AppText.label),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data?.gamemode ?? '—',
                style: AppText.titleL,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (language.isNotEmpty)
                Text(
                  language,
                  style: AppText.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialTile extends StatelessWidget {
  const _SocialTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.url,
  });

  final IconData icon;
  final String label;
  final Color color;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return GeoTile(
      color: color,
      semanticLabel: label,
      onTap: () => openLink(context, url),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26),
          const SizedBox(height: 8),
          Text(label.toUpperCase(), style: AppText.label),
        ],
      ),
    );
  }
}
