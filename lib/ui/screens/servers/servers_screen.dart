import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:artplay_launcher/bloc/server/server_bloc.dart';
import 'package:artplay_launcher/entities/server.dart';
import 'package:artplay_launcher/state/server_state_event.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_metrics.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/utils/actions.dart';
import 'package:artplay_launcher/ui/widgets/geo_shapes.dart';
import 'package:artplay_launcher/ui/widgets/screen_header.dart';
import 'package:artplay_launcher/ui/widgets/server_tile.dart';

/// Lista de servidores. Los datos vienen de [ServerBloc] (la misma fuente
/// que usa la pantalla de inicio), no se consultan por separado.
class ServersScreen extends StatelessWidget {
  const ServersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ServerBloc>();

    return StreamBuilder<ServerState>(
      stream: bloc.stateStream,
      initialData: bloc.currentState,
      builder: (context, snapshot) {
        final state = snapshot.data ?? bloc.currentState;
        final servers = state.serverInfos ?? const <ServerInfo>[];

        return Padding(
          padding: const EdgeInsets.all(AppMetrics.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                eyebrow: 'SA-MP',
                title: 'Servidores',
                trailing: IconButton(
                  tooltip: 'Actualizar',
                  color: AppColors.gold,
                  onPressed: state.isLoading ? null : bloc.refresh,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ),
              const SizedBox(height: 10),
              // Altura fija para que la lista no "salte" al aparecer la barra.
              SizedBox(
                height: 3,
                child: state.isLoading
                    ? const LinearProgressIndicator(minHeight: 3)
                    : null,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: servers.isNotEmpty
                    ? ListView.separated(
                        itemCount: servers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final info = servers[index];
                          return ServerTile(
                            info: info,
                            onTap: () => copyText(
                              context,
                              info.address,
                              message: 'Dirección copiada',
                            ),
                          );
                        },
                      )
                    : state.isLoading
                        ? const _Message(
                            title: 'Consultando servidores…',
                            subtitle: 'Esto puede tardar unos segundos.',
                          )
                        : _Message(
                            title: 'Sin respuesta del servidor',
                            subtitle:
                                'Revisa tu conexión e inténtalo de nuevo.',
                            onRetry: bloc.refresh,
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.subtitle, this.onRetry});

  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox.square(
              dimension: 52,
              child: CustomPaint(
                painter: AsteriskPainter(color: AppColors.gold, strokeWidth: 3),
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppText.titleL),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: AppText.body.copyWith(color: AppColors.creamDim),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('REINTENTAR'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
