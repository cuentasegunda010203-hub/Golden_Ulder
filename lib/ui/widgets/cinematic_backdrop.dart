import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:artplay_launcher/ui/theme/app_colors.dart';

/// Fondo ambiental dibujado en Flutter: no requiere imágenes ni conexión.
/// El puntero genera parallax en escritorio y las luces se mueven lentamente.
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
    duration: const Duration(seconds: 34),
  )..repeat();

  Offset _pointer = const Offset(0.5, 0.5);

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (event) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            if (width <= 0 || height <= 0) return;
            final next = Offset(
              (event.localPosition.dx / width).clamp(0.0, 1.0),
              (event.localPosition.dy / height).clamp(0.0, 1.0),
            );
            if ((next - _pointer).distance > 0.025) {
              setState(() => _pointer = next);
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: _motion,
                builder: (context, _) => CustomPaint(
                  painter: _ValdoriaCityPainter(
                    progress: _motion.value,
                    pointer: _pointer,
                  ),
                ),
              ),
              // Un velo que mejora el contraste y deja respirar el arte de fondo.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x54101520),
                      Color(0x8A0D1220),
                      Color(0xD90D1220),
                    ],
                    stops: [0, 0.55, 1],
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _ValdoriaCityPainter extends CustomPainter {
  const _ValdoriaCityPainter({required this.progress, required this.pointer});

  final double progress;
  final Offset pointer;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final bounds = Offset.zero & size;
    final center = Offset(
      size.width * (0.72 + (pointer.dx - 0.5) * 0.035),
      size.height * (0.35 + (pointer.dy - 0.5) * 0.025),
    );

    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C2638), Color(0xFF101624), Color(0xFF090D16)],
        ).createShader(bounds),
    );

    // Luz atmosférica borgoña y dorada, muy suave.
    canvas.drawCircle(
      center,
      size.shortestSide * 0.52,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.burgundy.withValues(alpha: 0.25),
            const Color(0x00151B2B),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: size.shortestSide * 0.52),
        ),
    );
    final goldCenter = Offset(size.width * 0.2, size.height * 0.16);
    canvas.drawCircle(
      goldCenter,
      size.shortestSide * 0.42,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.gold.withValues(alpha: 0.09),
            const Color(0x00151B2B),
          ],
        ).createShader(
          Rect.fromCircle(
            center: goldCenter,
            radius: size.shortestSide * 0.42,
          ),
        ),
    );

    _drawSkyline(
      canvas,
      size,
      baseline: size.height * 0.78,
      heightFactor: 0.27,
      color: const Color(0xFF20283A).withValues(alpha: 0.62),
      drift: -7,
      windows: false,
    );
    _drawSkyline(
      canvas,
      size,
      baseline: size.height * 0.86,
      heightFactor: 0.36,
      color: const Color(0xFF141D2D).withValues(alpha: 0.86),
      drift: 11,
      windows: true,
    );
    _drawSkyline(
      canvas,
      size,
      baseline: size.height * 0.96,
      heightFactor: 0.23,
      color: const Color(0xFF0B101B).withValues(alpha: 0.98),
      drift: -3,
      windows: true,
    );

    // Luces suspendidas en la atmósfera: posiciones deterministas y movimiento lento.
    for (var i = 0; i < 24; i++) {
      final seed = i * 17.17;
      final x = ((seed * 0.618 + progress * (i.isEven ? 0.018 : -0.012)) %
              1.0) *
          size.width;
      final y = (0.10 + ((seed * 0.137) % 0.64)) * size.height;
      final pulse = 0.22 + 0.28 * (0.5 + 0.5 * math.sin(progress * math.pi * 2 + seed));
      canvas.drawCircle(
        Offset(x, y),
        i % 5 == 0 ? 1.6 : 0.8,
        Paint()
          ..color = (i % 4 == 0 ? AppColors.gold : const Color(0xFFD9DDE8))
              .withValues(alpha: pulse),
      );
    }

    // Líneas arquitectónicas discretas, como un mapa urbano nocturno.
    final gridPaint = Paint()
      ..color = AppColors.cream.withValues(alpha: 0.035)
      ..strokeWidth = 0.7;
    for (var i = 1; i < 8; i++) {
      final y = size.height * (0.18 + i * 0.075);
      canvas.drawLine(
        Offset(size.width * 0.52, y),
        Offset(size.width, y - size.height * 0.08),
        gridPaint,
      );
    }
  }

  void _drawSkyline(
    Canvas canvas,
    Size size, {
    required double baseline,
    required double heightFactor,
    required Color color,
    required double drift,
    required bool windows,
  }) {
    final path = Path()..moveTo(0, baseline);
    final step = math.max(17.0, size.width / 38);
    var index = 0;
    for (double x = 0; x <= size.width + step; x += step) {
      final variation = ((index * 37) % 11) / 11;
      final buildingHeight = size.height * heightFactor * (0.32 + variation * 0.68);
      final left = x + drift * math.sin(progress * math.pi * 2 + index * 0.2);
      final width = step * (0.55 + ((index * 13) % 5) * 0.08);
      path
        ..lineTo(left, baseline - buildingHeight)
        ..lineTo(left + width, baseline - buildingHeight)
        ..lineTo(left + width, baseline);
      index++;
    }
    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);

    if (!windows) return;
    final windowPaint = Paint();
    index = 0;
    for (double x = 8; x < size.width; x += step) {
      final variation = ((index * 37) % 11) / 11;
      final buildingHeight = size.height * heightFactor * (0.32 + variation * 0.68);
      for (var row = 0; row < 5; row++) {
        for (var col = 0; col < 2; col++) {
          final wx = x + col * 6 + (index.isEven ? 1 : 4);
          final wy = baseline - buildingHeight + 12 + row * 12;
          if (wy < baseline - 4 && wx < size.width) {
            final shimmer = 0.18 +
                0.2 *
                    (0.5 +
                        0.5 *
                            math.sin(progress * math.pi * 2 + index * 1.7 + row));
            windowPaint.color = (index % 7 == 0
                    ? AppColors.gold
                    : const Color(0xFFB8C5D9))
                .withValues(alpha: shimmer);
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(wx, wy, 2.4, 4.0),
                const Radius.circular(0.7),
              ),
              windowPaint,
            );
          }
        }
      }
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant _ValdoriaCityPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pointer != pointer;
}
