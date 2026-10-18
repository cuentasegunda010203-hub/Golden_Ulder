import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:artplay_launcher/ui/theme/app_colors.dart';

/// Paisaje urbano tropical original inspirado en simuladores de ciudad móvil:
/// costa, montañas, barrios coloridos, palmeras y luz cálida. Todo se pinta
/// localmente, responde al tacto/ratón y no descarga imágenes externas.
class CinematicBackdrop extends StatefulWidget {
  const CinematicBackdrop({super.key, required this.child});

  final Widget child;

  @override
  State<CinematicBackdrop> createState() => _CinematicBackdropState();
}

class _CinematicBackdropState extends State<CinematicBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 42),
  )..repeat();

  Offset _pointer = const Offset(0.5, 0.5);

  void _movePointer(Offset position, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final next = Offset(
      (position.dx / size.width).clamp(0.0, 1.0).toDouble(),
      (position.dy / size.height).clamp(0.0, 1.0).toDouble(),
    );
    if ((next - _pointer).distance > 0.018) {
      setState(() => _pointer = next);
    }
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return Listener(
          onPointerDown: (event) => _movePointer(event.localPosition, size),
          onPointerMove: (event) => _movePointer(event.localPosition, size),
          child: MouseRegion(
            onHover: (event) => _movePointer(event.localPosition, size),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedBuilder(
                  animation: _motion,
                  builder: (context, _) => CustomPaint(
                    painter: _ValdoriaCoastPainter(
                      progress: _motion.value,
                      pointer: _pointer,
                    ),
                  ),
                ),
                // Sombra suave en el borde izquierdo y abajo para conservar
                // contraste con los paneles sin apagar el paisaje tropical.
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xA80B1723),
                        Color(0x56101C2A),
                        Color(0x120D1220),
                      ],
                      stops: [0, 0.48, 1],
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x15101B2B),
                        Color(0x18101B2B),
                        Color(0xA80D1220),
                      ],
                      stops: [0, 0.48, 1],
                    ),
                  ),
                ),
                widget.child,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ValdoriaCoastPainter extends CustomPainter {
  const _ValdoriaCoastPainter({
    required this.progress,
    required this.pointer,
  });

  final double progress;
  final Offset pointer;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final bounds = Offset.zero & size;
    final w = size.width;
    final h = size.height;
    final parallaxX = (pointer.dx - 0.5) * w * 0.035;
    final parallaxY = (pointer.dy - 0.5) * h * 0.025;

    // Tropical sunset sky, teal horizon and warm late-afternoon sunlight.
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF83B7C5),
            Color(0xFFB6C8C1),
            Color(0xFFF0B58B),
            Color(0xFFDE906E),
          ],
          stops: [0, 0.38, 0.67, 1],
        ).createShader(bounds),
    );

    final sunCenter = Offset(w * 0.76 + parallaxX, h * 0.31 + parallaxY);
    canvas.drawCircle(
      sunCenter,
      math.min(w, h) * 0.115,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFF0C6).withValues(alpha: 0.85),
            const Color(0xFFFFD49A).withValues(alpha: 0.24),
            const Color(0x00FFD49A),
          ],
          stops: const [0, 0.48, 1],
        ).createShader(
          Rect.fromCircle(center: sunCenter, radius: math.min(w, h) * 0.22),
        ),
    );
    canvas.drawCircle(
      sunCenter,
      math.min(w, h) * 0.052,
      Paint()..color = const Color(0xFFFFE4B4).withValues(alpha: 0.9),
    );

    _drawCloud(canvas, Offset(w * 0.20 + parallaxX * 0.45, h * 0.19), w * 0.11);
    _drawCloud(canvas, Offset(w * 0.55 + parallaxX * 0.35, h * 0.12), w * 0.075);
    _drawBirds(canvas, size);

    // Rio-inspired coastal mountains and the distant city.
    _drawMountain(canvas, size,
        points: [
          Offset(-w * 0.08, h * 0.57),
          Offset(w * 0.10, h * 0.39),
          Offset(w * 0.24, h * 0.52),
          Offset(w * 0.39, h * 0.34),
          Offset(w * 0.56, h * 0.52),
          Offset(w * 0.70, h * 0.40),
          Offset(w * 0.88, h * 0.53),
          Offset(w * 1.08, h * 0.36),
          Offset(w * 1.10, h * 0.76),
          Offset(-w * 0.08, h * 0.76),
        ],
        color: const Color(0xFF587D78).withValues(alpha: 0.66),
        offset: Offset(parallaxX * 0.55, parallaxY * 0.35));
    _drawMountain(canvas, size,
        points: [
          Offset(-w * 0.06, h * 0.64),
          Offset(w * 0.16, h * 0.49),
          Offset(w * 0.30, h * 0.60),
          Offset(w * 0.48, h * 0.46),
          Offset(w * 0.66, h * 0.63),
          Offset(w * 0.82, h * 0.47),
          Offset(w * 1.08, h * 0.63),
          Offset(w * 1.08, h * 0.80),
          Offset(-w * 0.06, h * 0.80),
        ],
        color: const Color(0xFF3D6662).withValues(alpha: 0.75),
        offset: Offset(parallaxX * 0.8, parallaxY * 0.55));

    _drawCoastalBuildings(canvas, size, parallaxX * 1.2);
    _drawHillsideNeighborhood(canvas, size, parallaxX * 1.6, parallaxY);
    _drawWaterfront(canvas, size, parallaxX);
    _drawPalm(canvas, Offset(w * 0.07 + parallaxX * 2.1, h * 0.80),
        scale: math.min(w, h) * 0.0012, sway: progress * math.pi * 2);
    _drawPalm(canvas, Offset(w * 0.91 + parallaxX * 2.2, h * 0.84),
        scale: math.min(w, h) * 0.00155, sway: progress * math.pi * 2 + 1.1);
    _drawPalm(canvas, Offset(w * 0.99 + parallaxX * 2.4, h * 0.90),
        scale: math.min(w, h) * 0.00105, sway: progress * math.pi * 2 + 2.2);

    _drawPromenade(canvas, size, parallaxX);
    _drawAtmosphere(canvas, size);
  }

  void _drawCloud(Canvas canvas, Offset center, double width) {
    final paint = Paint()..color = const Color(0xFFF9E5D2).withValues(alpha: 0.27);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: width * 0.19),
      paint,
    );
    canvas.drawCircle(Offset(center.dx - width * 0.17, center.dy - width * 0.035),
        width * 0.095, paint);
    canvas.drawCircle(Offset(center.dx + width * 0.04, center.dy - width * 0.06),
        width * 0.12, paint);
    canvas.drawCircle(Offset(center.dx + width * 0.20, center.dy - width * 0.015),
        width * 0.075, paint);
  }

  void _drawBirds(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF38575C).withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var i = 0; i < 5; i++) {
      final x = size.width * (0.36 + i * 0.028) +
          math.sin(progress * math.pi * 2 + i) * 4;
      final y = size.height * (0.28 + (i % 3) * 0.018);
      final path = Path()
        ..moveTo(x - 4, y + 1)
        ..quadraticBezierTo(x - 1, y - 3, x, y)
        ..quadraticBezierTo(x + 2, y - 3, x + 5, y + 1);
      canvas.drawPath(path, paint);
    }
  }

  void _drawMountain(
    Canvas canvas,
    Size size, {
    required List<Offset> points,
    required Color color,
    required Offset offset,
  }) {
    final path = Path()..moveTo(points.first.dx + offset.dx, points.first.dy + offset.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx + offset.dx, point.dy + offset.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawCoastalBuildings(Canvas canvas, Size size, double drift) {
    final w = size.width;
    final h = size.height;
    final baseline = h * 0.70;
    final buildings = <({double x, double width, double height, Color color})>[
      (x: 0.02, width: 0.055, height: 0.12, color: const Color(0xFFB7785C)),
      (x: 0.08, width: 0.035, height: 0.16, color: const Color(0xFFE1B68B)),
      (x: 0.13, width: 0.052, height: 0.11, color: const Color(0xFF648A84)),
      (x: 0.21, width: 0.04, height: 0.19, color: const Color(0xFFD8C3A2)),
      (x: 0.27, width: 0.07, height: 0.14, color: const Color(0xFF9A6F5E)),
      (x: 0.36, width: 0.045, height: 0.22, color: const Color(0xFF8FA8A0)),
      (x: 0.43, width: 0.06, height: 0.17, color: const Color(0xFFD8AD83)),
      (x: 0.52, width: 0.048, height: 0.25, color: const Color(0xFF668B8A)),
      (x: 0.60, width: 0.06, height: 0.19, color: const Color(0xFFE1C29B)),
      (x: 0.69, width: 0.05, height: 0.23, color: const Color(0xFFB77F65)),
      (x: 0.78, width: 0.06, height: 0.16, color: const Color(0xFF9AB1A6)),
      (x: 0.87, width: 0.05, height: 0.20, color: const Color(0xFFD7B58F)),
      (x: 0.94, width: 0.06, height: 0.13, color: const Color(0xFFB87C61)),
    ];
    for (var i = 0; i < buildings.length; i++) {
      final b = buildings[i];
      final left = w * b.x + drift + math.sin(progress * math.pi * 2 + i) * 1.8;
      final top = baseline - h * b.height;
      final width = w * b.width;
      final rect = Rect.fromLTWH(left, top, width, baseline - top);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        Paint()..color = b.color.withValues(alpha: 0.83),
      );
      canvas.drawRect(
        Rect.fromLTWH(left, top, width, 3),
        Paint()..color = const Color(0xFFFFD6A5).withValues(alpha: 0.75),
      );
      final columns = math.max(2, (width / 9).floor());
      for (var row = 0; row < 5; row++) {
        for (var col = 0; col < columns; col++) {
          final wx = left + 4 + col * (width - 7) / columns;
          final wy = top + 7 + row * 9.5;
          if (wy < baseline - 4) {
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(wx, wy, 2.5, 3.5),
                const Radius.circular(0.7),
              ),
              Paint()..color = const Color(0xFFFFE7B6).withValues(alpha: 0.55),
            );
          }
        }
      }
    }
  }

  void _drawHillsideNeighborhood(Canvas canvas, Size size, double drift, double verticalDrift) {
    final w = size.width;
    final h = size.height;
    final baseY = h * 0.76 + verticalDrift;
    final hill = Path()
      ..moveTo(w * 0.0, baseY)
      ..quadraticBezierTo(w * 0.22, h * 0.54 + verticalDrift, w * 0.42, h * 0.70)
      ..quadraticBezierTo(w * 0.68, h * 0.54, w * 0.91, h * 0.72)
      ..lineTo(w, h * 0.83)
      ..lineTo(0, h * 0.85)
      ..close();
    canvas.drawPath(hill, Paint()..color = const Color(0xFF365C51).withValues(alpha: 0.88));

    final colors = [
      const Color(0xFFDDA66F),
      const Color(0xFFB96F59),
      const Color(0xFFE4C79A),
      const Color(0xFF7E9A83),
      const Color(0xFFCA8D6A),
      const Color(0xFF9BB2A0),
      const Color(0xFFE5B883),
    ];
    for (var i = 0; i < 45; i++) {
      final band = i % 3;
      final x = ((i * 0.071 + (band * 0.04)) % 1.0) * w + drift;
      final ridge = h * (0.62 + band * 0.047) +
          math.sin(i * 1.73) * h * 0.027 + verticalDrift;
      final bw = w * (0.018 + (i % 4) * 0.006);
      final bh = h * (0.027 + (i % 5) * 0.008);
      final rect = Rect.fromLTWH(x, ridge - bh, bw, bh);
      canvas.drawRect(rect, Paint()..color = colors[i % colors.length].withValues(alpha: 0.92));
      canvas.drawRect(
        Rect.fromLTWH(x, ridge - bh, bw, 2),
        Paint()..color = const Color(0xFFFFD5A1).withValues(alpha: 0.55),
      );
      if (bw > 10) {
        canvas.drawRect(
          Rect.fromLTWH(x + 3, ridge - bh + 5, 2.2, 3),
          Paint()..color = const Color(0xFF344B4A).withValues(alpha: 0.65),
        );
      }
    }
  }

  void _drawWaterfront(Canvas canvas, Size size, double drift) {
    final w = size.width;
    final h = size.height;
    final y = h * 0.70;
    final water = Path()
      ..moveTo(0, y)
      ..quadraticBezierTo(w * 0.45, y + h * 0.018, w, y - h * 0.01)
      ..lineTo(w, h * 0.88)
      ..lineTo(0, h * 0.88)
      ..close();
    canvas.drawPath(
      water,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6D9C98), Color(0xFF477C7D), Color(0xFF315E67)],
        ).createShader(Rect.fromLTWH(0, y, w, h * 0.18)),
    );
    final glint = Paint()
      ..color = const Color(0xFFFFE0B1).withValues(alpha: 0.28)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 30; i++) {
      final x = ((i * 0.137 + progress * (i.isEven ? 0.025 : -0.018)) % 1.0) * w;
      final yy = y + h * (0.018 + (i % 6) * 0.012);
      final length = w * (0.008 + (i % 3) * 0.003);
      canvas.drawLine(Offset(x + drift * 0.2, yy), Offset(x + length, yy), glint);
    }
  }

  void _drawPalm(Canvas canvas, Offset base, {required double scale, required double sway}) {
    final trunkHeight = scale * 145;
    final swayOffset = math.sin(sway) * scale * 13;
    final top = Offset(base.dx + swayOffset, base.dy - trunkHeight);
    final trunk = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(base.dx + swayOffset * 0.4, base.dy - trunkHeight * 0.5,
          top.dx, top.dy);
    canvas.drawPath(
      trunk,
      Paint()
        ..color = const Color(0xFF5C493B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = scale * 7
        ..strokeCap = StrokeCap.round,
    );
    final leafPaint = Paint()
      ..color = const Color(0xFF244D43)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 4
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 7; i++) {
      final angle = -math.pi + i * math.pi / 6;
      final length = scale * (65 + (i % 3) * 8);
      final end = Offset(
        top.dx + math.cos(angle + 0.1) * length,
        top.dy + math.sin(angle + 0.1) * length * 0.53 - scale * 9,
      );
      final path = Path()
        ..moveTo(top.dx, top.dy)
        ..quadraticBezierTo(
          top.dx + math.cos(angle) * length * 0.58,
          top.dy + math.sin(angle) * length * 0.46 - scale * 12,
          end.dx,
          end.dy,
        );
      canvas.drawPath(path, leafPaint);
      for (var j = 1; j <= 4; j++) {
        final t = j / 5;
        final px = top.dx + (end.dx - top.dx) * t;
        final py = top.dy + (end.dy - top.dy) * t;
        final side = (j.isEven ? 1 : -1) * scale * 5;
        canvas.drawLine(
          Offset(px, py),
          Offset(px + side, py + scale * 3),
          Paint()
            ..color = const Color(0xFF47735A)
            ..strokeWidth = scale * 1.8,
        );
      }
    }
  }

  void _drawPromenade(Canvas canvas, Size size, double drift) {
    final w = size.width;
    final h = size.height;
    final road = Path()
      ..moveTo(w * 0.26, h)
      ..lineTo(w * 0.42, h * 0.82)
      ..lineTo(w * 0.62, h * 0.82)
      ..lineTo(w * 0.88, h)
      ..close();
    canvas.drawPath(road, Paint()..color = const Color(0xFF4C4C48).withValues(alpha: 0.88));
    final edge = Paint()
      ..color = const Color(0xFFE6C49A).withValues(alpha: 0.68)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(w * 0.42 + drift * 0.2, h * 0.82), Offset(w * 0.26, h), edge);
    canvas.drawLine(Offset(w * 0.62 + drift * 0.2, h * 0.82), Offset(w * 0.88, h), edge);

    // Pavement joints create depth and a subtle forward perspective.
    final paving = Paint()
      ..color = const Color(0xFFFFD6A2).withValues(alpha: 0.16)
      ..strokeWidth = 0.8;
    for (var i = 1; i <= 6; i++) {
      final t = i / 7;
      final y = h * (0.83 + t * 0.16);
      canvas.drawLine(Offset(w * (0.41 - t * 0.15), y), Offset(w * (0.63 + t * 0.24), y), paving);
    }
  }

  void _drawAtmosphere(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Gentle moving reflections and airborne dust, kept subtle behind content.
    for (var i = 0; i < 18; i++) {
      final seed = i * 19.31;
      final x = ((seed * 0.618 + progress * (i.isEven ? 0.015 : -0.009)) % 1.0) * w;
      final y = h * (0.12 + (seed * 0.137 % 0.72));
      final alpha = 0.12 + 0.10 * (0.5 + 0.5 * math.sin(progress * math.pi * 2 + seed));
      canvas.drawCircle(
        Offset(x, y),
        i % 4 == 0 ? 1.5 : 0.8,
        Paint()..color = const Color(0xFFFFE3B9).withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ValdoriaCoastPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pointer != pointer;
}
