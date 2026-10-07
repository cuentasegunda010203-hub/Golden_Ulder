import 'package:flutter/material.dart';

import 'package:artplay_launcher/ui/theme/app_colors.dart';

/// Panel rectangular del "mosaico" (esquinas rectas, sin separación).
///
/// - Pinta [color] como fondo y pone texto/iconos en el color de contraste
///   correcto (negro sobre crema/dorado, crema sobre negro).
/// - [decorations] son formas geométricas (normalmente `Positioned`) dibujadas
///   DETRÁS del contenido y recortadas al borde del panel.
/// - Si hay [onTap], el panel responde con ripple.
///
/// Debe usarse dentro de un padre con tamaño acotado (Expanded, SizedBox...).
class GeoTile extends StatelessWidget {
  const GeoTile({
    super.key,
    required this.color,
    this.child,
    this.decorations = const <Widget>[],
    this.padding = const EdgeInsets.all(14),
    this.onTap,
    this.semanticLabel,
  });

  final Color color;
  final Widget? child;
  final List<Widget> decorations;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final foreground = AppColors.on(color);

    Widget tile = Material(
      color: color,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        splashColor: foreground.withValues(alpha: 0.14),
        highlightColor: foreground.withValues(alpha: 0.07),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: foreground),
          child: IconTheme.merge(
            data: IconThemeData(color: foreground),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ...decorations,
                Padding(padding: padding, child: child),
              ],
            ),
          ),
        ),
      ),
    );

    if (semanticLabel != null) {
      tile = Semantics(
        container: true,
        button: onTap != null,
        label: semanticLabel,
        child: tile,
      );
    }

    return tile;
  }
}
