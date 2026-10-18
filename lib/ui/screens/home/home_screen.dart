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
import 'package:artplay_launcher/ui/widgets/cinematic_backdrop.dart';
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

        final viewport = MediaQuery.sizeOf(context);
        // En ventanas bajas, la composición horizontal no tiene altura suficiente
        // para el hero y el panel de acceso. Usa la variante desplazable para evitar
        // RenderFlex overflow en escritorios pequeños o con zoom del sistema.
        if (viewport.width < 650 || viewport.height < 720) {
          return CinematicBackdrop(
            child: _CompactHome(
              state: state,
              info: info,
              onRefresh: state.isLoading ? null : bloc.refresh,
              onPlay: () => showAppSnack(
                context,
                'El lanzamiento del juego aún no está configurado.',
              ),
            ),
          );
        }

        return CinematicBackdrop(
          child: Padding(
            padding: const EdgeInsets.all(AppMetrics.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              const SizedBox(height: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 7,
                      child: _CinematicHero(
                        status: state.status,
                        onPlay: () => showAppSnack(
                          context,
                          'El lanzamiento del juego aún no está configurado.',
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: _MetricPanel(
                              icon: Icons.groups_2_rounded,
                              label: 'JUGADORES EN LÍNEA',
                              value: info == null ? '—' : '${info.players}',
                              detail: info == null
                                  ? 'Esperando respuesta del servidor'
                                  : 'de ${info.maxPlayers} plazas disponibles',
                              accent: AppColors.gold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricPanel(
                              icon: Icons.speed_rounded,
                              label: 'LATENCIA',
                              value: info?.pingMs == null ? '—' : '${info!.pingMs}',
                              detail: info?.pingMs == null
                                  ? 'Sin medición disponible'
                                  : 'Conexión en milisegundos',
                              accent: AppColors.cream,
                              suffix: info?.pingMs == null ? null : ' ms',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricPanel(
                              icon: Icons.sports_esports_rounded,
                              label: 'MODO DE JUEGO',
                              value: info?.gamemode ?? 'ROLEPLAY',
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
              const SizedBox(height: 12),
              _FooterBar(
                isLoading: state.isLoading,
                onRefresh: state.isLoading ? null : bloc.refresh,
              ),
            ],
          ),
        ));
      },
    );
  }
}

class _CompactHome extends StatelessWidget {
  const _CompactHome({
    required this.state,
    required this.info,
    required this.onRefresh,
    required this.onPlay,
  });

  final ServerState state;
  final ServerInfo? info;
  final VoidCallback? onRefresh;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CompactTopBar(),
          const SizedBox(height: 18),
          _CompactHero(status: state.status, onPlay: onPlay),
          const SizedBox(height: 14),
          _MetricPanel(
            icon: Icons.groups_2_rounded,
            label: 'JUGADORES EN LÍNEA',
            value: info == null ? '—' : '${info!.players}',
            detail: info == null
                ? 'Esperando respuesta del servidor'
                : 'de ${info!.maxPlayers} plazas disponibles',
            accent: AppColors.gold,
            fixedHeight: 94,
          ),
          const SizedBox(height: 10),
          _MetricPanel(
            icon: Icons.speed_rounded,
            label: 'LATENCIA',
            value: info?.pingMs == null ? '—' : '${info!.pingMs}',
            detail: info?.pingMs == null
                ? 'Sin medición disponible'
                : 'Conexión en milisegundos',
            accent: AppColors.cream,
            suffix: info?.pingMs == null ? null : ' ms',
            fixedHeight: 94,
          ),
          const SizedBox(height: 10),
          _MetricPanel(
            icon: Icons.sports_esports_rounded,
            label: 'MODO DE JUEGO',
            value: info?.gamemode ?? 'ROLEPLAY',
            detail: info?.language ?? 'San Andreas Multiplayer',
            accent: AppColors.cream,
            compactValue: true,
            fixedHeight: 94,
          ),
          const SizedBox(height: 12),
          _FooterBar(isLoading: state.isLoading, onRefresh: onRefresh),
        ],
      ),
    );
  }
}

class _CompactTopBar extends StatelessWidget {
  const _CompactTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 39,
          height: 43,
          decoration: BoxDecoration(
            color: AppColors.burgundy,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
              bottom: Radius.circular(12),
            ),
            border: Border.all(color: AppColors.gold, width: 1.1),
          ),
          child: const Icon(Icons.shield_rounded, color: AppColors.gold, size: 25),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VALDORIA RP',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.cream,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'SAN ANDREAS • ROLEPLAY',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.creamDim,
                  fontSize: 8,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Discord',
          onPressed: () => openLink(context, AppConfig.discordUrl),
          icon: const Icon(Icons.forum_outlined, size: 19),
          color: AppColors.creamDim,
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          tooltip: 'Sitio web',
          onPressed: () => openLink(context, AppConfig.websiteUrl),
          icon: const Icon(Icons.language_rounded, size: 19),
          color: AppColors.creamDim,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _CompactHero extends StatelessWidget {
  const _CompactHero({required this.status, required this.onPlay});

  final ServerStatus status;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.42)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.inkRaised.withValues(alpha: 0.75),
            AppColors.inkDeep.withValues(alpha: 0.88),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'UN NUEVO MUNDO TE ESPERA',
                style: AppText.label.copyWith(
                  color: AppColors.gold,
                  fontSize: 8,
                  letterSpacing: 1.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'TU HISTORIA\nCOMIENZA EN',
            style: AppText.display.copyWith(
              color: AppColors.cream,
              fontSize: 31,
              height: 1.04,
            ),
          ),
          Text(
            'VALDORIA.',
            style: AppText.display.copyWith(
              color: AppColors.gold,
              fontSize: 39,
              height: 1.1,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppConfig.tagline,
            style: AppText.body.copyWith(
              color: AppColors.creamDim,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 17),
          StatusChip(status: status),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => copyText(
              context,
              AppConfig.address,
              message: 'Dirección del servidor copiada',
            ),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.inkDeep.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.inkLine),
              ),
              child: Row(
                children: [
                  const Icon(Icons.dns_rounded, color: AppColors.gold, size: 15),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      AppConfig.address,
                      style: AppText.caption.copyWith(color: AppColors.cream),
                    ),
                  ),
                  const Icon(Icons.copy_rounded, size: 13, color: AppColors.creamDim),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.burgundy,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: onPlay,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded, color: AppColors.gold, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'JUGAR AHORA',
                        style: AppText.label.copyWith(
                          color: AppColors.cream,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.gold, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CinematicHero extends StatelessWidget {
  const _CinematicHero({required this.status, required this.onPlay});

  final ServerStatus status;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.36)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.inkRaised.withValues(alpha: 0.48),
            AppColors.inkDeep.withValues(alpha: 0.66),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20,
            top: -36,
            child: Text(
              'V',
              style: TextStyle(
                fontSize: 330,
                height: 1,
                fontWeight: FontWeight.w700,
                color: AppColors.cream.withValues(alpha: 0.035),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.gold.withValues(alpha: 0.05),
                    AppColors.gold,
                    AppColors.burgundy,
                    AppColors.burgundy.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 25, 28, 25),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Text(
                            'UN NUEVO MUNDO TE ESPERA',
                            style: AppText.label.copyWith(
                              color: AppColors.gold,
                              letterSpacing: 2.0,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'TU HISTORIA\nCOMIENZA EN',
                        style: AppText.display.copyWith(
                          color: AppColors.cream,
                          fontSize: 35,
                          height: 1.02,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'VALDORIA.',
                        style: AppText.display.copyWith(
                          color: AppColors.gold,
                          fontSize: 43,
                          height: 1.06,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 13),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Text(
                          AppConfig.tagline,
                          style: AppText.body.copyWith(
                            color: AppColors.creamDim,
                            height: 1.6,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 19),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          StatusChip(status: status),
                          InkWell(
                            onTap: () => copyText(
                              context,
                              AppConfig.address,
                              message: 'Dirección del servidor copiada',
                            ),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.inkDeep.withValues(alpha: 0.72),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.inkLine),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.dns_rounded,
                                    size: 14,
                                    color: AppColors.gold,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppConfig.address,
                                    style: AppText.caption.copyWith(
                                      color: AppColors.cream,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.copy_rounded,
                                    size: 12,
                                    color: AppColors.creamDim,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260),
                      child: _HeroActionCard(onTap: onPlay),
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

class _HeroActionCard extends StatefulWidget {
  const _HeroActionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_HeroActionCard> createState() => _HeroActionCardState();
}

class _HeroActionCardState extends State<_HeroActionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.burgundy : AppColors.burgundy.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: _hovered ? 0.95 : 0.58),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.burgundy.withValues(alpha: _hovered ? 0.32 : 0.12),
              blurRadius: _hovered ? 26 : 12,
              spreadRadius: _hovered ? 1 : 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 49,
              height: 49,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 34,
                color: AppColors.inkDeep,
              ),
            ),
            const SizedBox(height: 23),
            Text(
              'ENTRAR AL\nSERVIDOR',
              style: AppText.display.copyWith(
                color: AppColors.cream,
                fontSize: 24,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Conecta con la ciudad y empieza tu próxima vida.',
              style: AppText.body.copyWith(
                color: AppColors.creamDim,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 21),
            Material(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(7),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'JUGAR AHORA',
                        style: AppText.label.copyWith(
                          color: AppColors.inkDeep,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 9),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.inkDeep,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 11),
            Center(
              child: Text(
                'SA-MP  •  ROLEPLAY HISPANO',
                style: AppText.label.copyWith(
                  color: AppColors.creamDim,
                  fontSize: 8,
                  letterSpacing: 0.8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
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
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Discord',
          onPressed: () => openLink(context, AppConfig.discordUrl),
          icon: const Icon(Icons.forum_outlined, size: 19),
          color: AppColors.creamDim,
          splashRadius: 20,
        ),
        IconButton(
          tooltip: 'Sitio web',
          onPressed: () => openLink(context, AppConfig.websiteUrl),
          icon: const Icon(Icons.language_rounded, size: 19),
          color: AppColors.creamDim,
          splashRadius: 20,
        ),
      ],
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
    this.fixedHeight,
  });

  final IconData icon;
  final String label;
  final String value;
  final String detail;
  final Color accent;
  final String? suffix;
  final bool compactValue;
  final double? fixedHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fixedHeight,
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
