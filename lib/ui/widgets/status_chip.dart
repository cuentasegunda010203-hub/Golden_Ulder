import 'package:flutter/material.dart';

import 'package:artplay_launcher/state/server_state_event.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';

/// Indicador "EN LÍNEA / SIN CONEXIÓN / CONECTANDO" del servidor.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final ServerStatus status;

  @override
  Widget build(BuildContext context) {
    final (String label, Color dot) = switch (status) {
      ServerStatus.online => ('EN LÍNEA', AppColors.online),
      ServerStatus.offline => ('SIN CONEXIÓN', AppColors.offline),
      ServerStatus.connecting => ('CONECTANDO', AppColors.gold),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cream.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: AppText.label),
        ],
      ),
    );
  }
}
