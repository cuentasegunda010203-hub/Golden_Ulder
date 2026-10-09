import 'package:flutter/material.dart';

import 'package:artplay_launcher/bloc/ui/pager_bloc.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/theme/app_metrics.dart';
import 'package:artplay_launcher/ui/theme/app_theme.dart';
import 'package:artplay_launcher/ui/widgets/brand_mark.dart';

/// Navegación lateral conservando la identidad geométrica del launcher.
class AppNavRail extends StatelessWidget {
  const AppNavRail({
    super.key,
    required this.current,
    required this.onSelected,
  });

  final AppPage current;
  final ValueChanged<AppPage> onSelected;

  static const _items = <_RailItem>[
    _RailItem(AppPage.home, Icons.home_rounded, 'Inicio'),
    _RailItem(AppPage.servers, Icons.dns_rounded, 'Servidores'),
    _RailItem(AppPage.downloads, Icons.download_rounded, 'Descargas'),
    _RailItem(AppPage.settings, Icons.tune_rounded, 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppMetrics.railWidth,
      color: AppColors.ink,
      child: Column(
        children: [
          const BrandMark(size: AppMetrics.railWidth),
          for (final item in _items)
            _RailButton(
              item: item,
              selected: item.page == current,
              onTap: () => onSelected(item.page),
            ),
        ],
      ),
    );
  }
}

class _RailItem {
  const _RailItem(this.page, this.icon, this.label);

  final AppPage page;
  final IconData icon;
  final String label;
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _RailItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.ink : AppColors.creamDim;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: AppMetrics.railItemHeight,
        width: double.infinity,
        color: selected ? AppColors.gold : Colors.transparent,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.cream.withValues(alpha: 0.12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 24, color: foreground),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: AppText.label.copyWith(
                    color: foreground,
                    fontSize: 9.5,
                    letterSpacing: 0.4,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
