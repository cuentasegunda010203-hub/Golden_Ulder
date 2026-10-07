import 'package:flutter/material.dart';

import 'package:artplay_launcher/ui/theme/app_colors.dart';
import 'package:artplay_launcher/ui/widgets/geo_shapes.dart';

/// Marca del launcher: cuadrado oscuro con asterisco dorado.
///
/// (Fondo oscuro a propósito: así no se funde con el botón dorado de la
/// página seleccionada en la barra lateral.)
///
/// Es un marcador de posición dibujado por código. Cuando exista un logo
/// vectorial/transparente del servidor, se sustituye aquí y se actualiza
/// en todas las pantallas a la vez.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: ColoredBox(
        color: AppColors.inkRaised,
        child: Padding(
          padding: EdgeInsets.all(size * 0.24),
          child: CustomPaint(
            painter: AsteriskPainter(
              color: AppColors.gold,
              strokeWidth: size * 0.055,
            ),
          ),
        ),
      ),
    );
  }
}
