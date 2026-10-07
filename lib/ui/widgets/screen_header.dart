import 'package:flutter/material.dart';

import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';

/// Cabecera común de las pantallas: etiqueta dorada + título + acción opcional.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                eyebrow,
                style: AppText.label.copyWith(color: AppColors.gold),
              ),
              const SizedBox(height: 4),
              Text(title, style: AppText.heading),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
