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
import 'package:artplay_launcher/ui/widgets/status_chip.dart';

/// Dashboard de Valdoria RP: estética clásica de launcher de PC,
/// jerarquía clara, paneles oscuros y acentos heráldicos discretos.
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 6,
                            child: _WelcomePanel(status: state.status),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _MetricPanel(
                                    icon: Icons.groups_2_rounded,
                                    label: 'JUGADORES',
                                    value: info == null
                                        ? '—'
                                        : '${info.players}',
                                    detail: info == null
                                        ? 'Esperando respuesta'
                                        : 'de ${info.maxPlayers} plazas',
                                    accent: AppColors.gold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _MetricPanel(
                                    icon: Icons.speed_rounded,
                                    label: 'LATENCIA',
                                    value: info?.pingMs == null ? '—' : '${info!.pingMs}',
                                    detail: info?.pingMs == null ? 'Sin datos' : 'milisegundos',
                                    accent: AppColors.cream,
                                    suffix: info?.pingMs == null ? null : ' ms',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _MetricPanel(
                                    icon: Icons.sports_esports_rounded,
                                    label: 'MODO DE JUEGO',
                                    value: info?.gamemode ?? '—',
                                    detail: info?.language ?? 'San Andreas Multiplayer',
                                    accent: AppColors.cream,
                                    compactValue: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 7,
                            child: _PlayPanel(onTap: () {
                              showAppSnack(
                                context,
                                'El lanzamiento del juego aún no está configurado.',
                              );
                            }),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _QuickLink(
                                    icon: Icons.forum_rounded,
                                    label: 'DISCORD',
                                    enabled: AppConfig.discordUrl != null,
                                    onTap: () => openLink(
                                      context,
                                      AppConfig.discordUrl,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _QuickLink(
                                    icon: Icons.language_rounded,
                                    label: 'SITIO WEB',
                                    enabled: AppConfig.websiteUrl != null,
                                    onTap: () => openLink(
                                      context,
                                      AppConfig.websiteUrl,
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
              ),
              const SizedBox(height: 12),
              _FooterBar(
                isLoading: state.isLoading,
                onRefresh: state.isLoading ? null : bloc.refresh,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.burgundy,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
              bottom: Radius.circular(13),
            ),
            border: Border.all(color: AppColors.gold, width: 1.2),
          ),
          child: const Icon(
            Icons.shield_rounded,
            color: AppColors.gold,
            size: 27,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VALDORIA RP',
                style: AppText.titleL.copyWith(
                  color: AppColors.cream,
                  letterSpacing: 2.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'SAN ANDREAS MULTIPLAYER  /  ROLEPLAY',
                style: AppText.label.copyWith(
                  color: AppColors.creamDim,
                  letterSpacing: 1.05,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.ink,
            border: Border.all(color: AppColors.inkLine),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.circle, color: AppColors.gold, size: 7),
              const SizedBox(width: 7),
              Text(
                'EDICIÓN ROLEPLAY',
                style: AppText.label.copyWith(
                  color: AppColors.creamDim,
                  letterSpacing: 0.8,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.status});

  final ServerStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.inkLine),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.inkRaised, AppColors.ink],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -22,
            top: -36,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.10),
                  width: 1.2,
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: -3,
            child: Icon(
              Icons.shield_rounded,
              size: 190,
              color: AppColors.cream.withValues(alpha: 0.035),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.burgundy.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'TU HISTORIA COMIENZA AQUÍ',
                        style: AppText.label.copyWith(
                          color: AppColors.cream,
                          letterSpacing: 1.0,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Una ciudad.\nMiles de historias.',
                      style: AppText.display.copyWith(
                        color: AppColors.cream,
                        fontSize: 32,
                        height: 1.12,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 9),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Text(
                        AppConfig.tagline,
                        style: AppText.body.copyWith(
                          color: AppColors.creamDim,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    StatusChip(status: status),
                    const SizedBox(width: 9),
                    Flexible(
                      child: _AddressChip(),
                    ),
                  ],
                ),
              ],
            ),
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
      borderRadius: BorderRadius.circular(5),
      onTap: () => copyText(
        context,
        AppConfig.address,
        message: 'Dirección copiada',
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.inkDeep.withValues(alpha: 0.55),
          border: Border.all(color: AppColors.inkLine),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.dns_rounded, size: 14, color: AppColors.gold),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                AppConfig.address,
                style: AppText.caption.copyWith(color: AppColors.cream),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 7),
            const Icon(
              Icons.content_copy_rounded,
              size: 12,
              color: AppColors.creamDim,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricPanel extends StatelessWidget {
  const _MetricPanel({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
    required this.accent,
    this.suffix,
    this.compactValue = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String detail;
  final Color accent;
  final String? suffix;
  final bool compactValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.inkLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: accent),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  style: AppText.label.copyWith(
                    color: AppColors.creamDim,
                    letterSpacing: 0.9,
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: (compactValue ? AppText.titleL : AppText.metric)
                          .copyWith(color: accent),
                    ),
                    if (suffix != null)
                      TextSpan(
                        text: suffix,
                        style: AppText.caption.copyWith(color: AppColors.creamDim),
                      ),
                  ],
                ),
                maxLines: 1,
              ),
            ),
          ),
          Text(
            detail,
            style: AppText.caption.copyWith(color: AppColors.creamDim),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PlayPanel extends StatelessWidget {
  const _PlayPanel({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.burgundy,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.65)),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -12,
                right: -12,
                child: Icon(
                  Icons.shield_rounded,
                  size: 120,
                  color: AppColors.cream.withValues(alpha: 0.055),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.inkDeep,
                      size: 34,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'ENTRAR A\nVALDORIA',
                    style: AppText.display.copyWith(
                      color: AppColors.cream,
                      fontSize: 25,
                      height: 1.12,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Conéctate y escribe tu historia',
                    style: AppText.body.copyWith(color: AppColors.creamDim),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.gold.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: AppColors.inkLine),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 21,
                color: enabled ? AppColors.gold : AppColors.creamDim,
              ),
              const SizedBox(height: 7),
              Text(
                label,
                style: AppText.label.copyWith(
                  color: enabled ? AppColors.cream : AppColors.creamDim,
                  fontSize: 8.5,
                  letterSpacing: 0.6,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!enabled) ...[
                const SizedBox(height: 3),
                Text(
                  'PRONTO',
                  style: AppText.caption.copyWith(
                    color: AppColors.creamDim.withValues(alpha: 0.65),
                    fontSize: 8,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterBar extends StatelessWidget {
  const _FooterBar({required this.isLoading, required this.onRefresh});

  final bool isLoading;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 39,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.ink,
        border: Border.all(color: AppColors.inkLine),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            isLoading ? Icons.sync_rounded : Icons.verified_user_outlined,
            size: 15,
            color: AppColors.gold,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isLoading
                  ? 'Consultando el estado del servidor…'
                  : 'SERVIDOR PRINCIPAL  •  ${AppConfig.address}',
              style: AppText.caption.copyWith(
                color: AppColors.creamDim,
                letterSpacing: 0.25,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded, size: 15),
            label: const Text('ACTUALIZAR'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.gold,
              textStyle: AppText.label.copyWith(fontSize: 9, letterSpacing: 0.5),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 30),
            ),
          ),
        ],
      ),
    );
  }
}
