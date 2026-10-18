import 'package:flutter/material.dart';

import 'package:artplay_launcher/ui/theme/app_colors.dart';

/// Emblema compacto de Valdoria RP, compartido por la navegación.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Center(
        child: Container(
          width: size * 0.62,
          height: size * 0.70,
          decoration: BoxDecoration(
            color: AppColors.burgundy,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(size * 0.05),
              bottom: Radius.circular(size * 0.20),
            ),
            border: Border.all(
              color: AppColors.gold,
              width: size * 0.018,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.burgundy.withValues(alpha: 0.28),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.shield_rounded,
            size: size * 0.39,
            color: AppColors.gold,
          ),
        ),
      ),
    );
  }
}
