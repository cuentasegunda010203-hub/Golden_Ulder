// Copyright 2022-2023 Marlon "Eiss" Lorram. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Flutter
import 'package:flutter/material.dart';

// Internal
import 'package:artplay_launcher/entities/server.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/widgets/geo_shapes.dart';

/// Fila de la lista de servidores.
///
/// Muestra nombre, dirección, modo de juego, ocupación y calidad de señal.
/// Al tocarla se ejecuta [onTap] (p. ej. copiar la dirección o seleccionarlo).
class ServerTile extends StatelessWidget {
  /// Información del servidor a mostrar.
  final ServerInfo info;

  /// Acción al tocar la fila.
  final VoidCallback onTap;

  const ServerTile({
    super.key,
    required this.info,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      clipBehavior: Clip.hardEdge,
      // Barra dorada a la izquierda (acento de la plantilla).
      shape: const Border(left: BorderSide(color: AppColors.gold, width: 5)),
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.cream.withValues(alpha: 0.10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              // Nombre + dirección
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        if (info.hasPassword)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.lock_rounded,
                              size: 14,
                              color: AppColors.gold,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            info.hostname,
                            style: AppText.titleL,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      info.address,
                      style: AppText.caption.copyWith(color: AppColors.creamDim),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Modo de juego
              Expanded(
                flex: 3,
                child: _Stat(label: 'MODO', value: info.gamemode),
              ),
              const SizedBox(width: 16),
              // Jugadores + barra de ocupación
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Stat(
                      label: 'JUGADORES',
                      value: '${info.players} / ${info.maxPlayers}',
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: info.fill,
                      minHeight: 3,
                      color: AppColors.gold,
                      backgroundColor: AppColors.inkLine,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Señal
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 30,
                    height: 24,
                    child: CustomPaint(
                      painter: SignalBarsPainter(
                        level: info.signalLevel,
                        activeColor: AppColors.gold,
                        inactiveColor: AppColors.inkLine,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info.pingMs == null ? '— ms' : '${info.pingMs} ms',
                    style: AppText.caption.copyWith(color: AppColors.creamDim),
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

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppText.label.copyWith(color: AppColors.gold)),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppText.titleM,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
