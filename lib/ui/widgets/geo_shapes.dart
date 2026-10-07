import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Formas geométricas de la plantilla (franjas, círculos concéntricos,
/// asterisco, semicírculos). Todas se dibujan con CustomPainter: no usan
/// imágenes, escalan a cualquier pantalla y pesan 0 bytes en assets.

/// Franjas paralelas horizontales o verticales.
class StripesPainter extends CustomPainter {
  const StripesPainter({
    required this.color,
    this.count = 7,
    this.thickness = 0.5,
    this.vertical = false,
  });

  final Color color;
  final int count;

  /// Grosor de cada franja como fracción del paso (0..1).
  final double thickness;
  final bool vertical;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final extent = vertical ? size.width : size.height;
    final step = extent / count;
    final bar = step * thickness;

    for (var i = 0; i < count; i++) {
      final offset = i * step + (step - bar) / 2;
      final rect = vertical
          ? Rect.fromLTWH(offset, 0, bar, size.height)
          : Rect.fromLTWH(0, offset, size.width, bar);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(StripesPainter old) =>
      old.color != color ||
      old.count != count ||
      old.thickness != thickness ||
      old.vertical != vertical;
}

/// Círculos (o cuadrados) concéntricos, solo contorno.
class ConcentricPainter extends CustomPainter {
  const ConcentricPainter({
    required this.color,
    this.rings = 3,
    this.square = false,
    this.strokeWidth = 3,
  });

  final Color color;
  final int rings;
  final bool square;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;

    for (var i = 0; i < rings; i++) {
      final radius = maxRadius * (1 - i / rings) - strokeWidth / 2;
      if (radius <= 0) continue;
      if (square) {
        canvas.drawRect(Rect.fromCircle(center: center, radius: radius), paint);
      } else {
        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ConcentricPainter old) =>
      old.color != color ||
      old.rings != rings ||
      old.square != square ||
      old.strokeWidth != strokeWidth;
}

/// Asterisco de 8 puntas (el de la plantilla).
class AsteriskPainter extends CustomPainter {
  const AsteriskPainter({required this.color, this.strokeWidth = 3});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;

    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 4;
      final delta = Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      canvas.drawLine(center - delta, center + delta, paint);
    }
  }

  @override
  bool shouldRepaint(AsteriskPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

/// Medidor circular (p. ej. ocupación de jugadores).
class RingGaugePainter extends CustomPainter {
  const RingGaugePainter({
    required this.value,
    required this.color,
    required this.trackColor,
    this.strokeWidth = 7,
  });

  /// 0.0 a 1.0
  final double value;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    final progress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * value.clamp(0.0, 1.0),
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(RingGaugePainter old) =>
      old.value != value ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.strokeWidth != strokeWidth;
}

/// Barras de señal (calidad de conexión). [level] va de 0 a [bars].
class SignalBarsPainter extends CustomPainter {
  const SignalBarsPainter({
    required this.level,
    required this.activeColor,
    required this.inactiveColor,
    this.bars = 4,
  });

  final int level;
  final Color activeColor;
  final Color inactiveColor;
  final int bars;

  @override
  void paint(Canvas canvas, Size size) {
    final gap = size.width * 0.1;
    final barWidth = (size.width - gap * (bars - 1)) / bars;

    for (var i = 0; i < bars; i++) {
      final height = size.height * (i + 1) / bars;
      final rect = Rect.fromLTWH(
        i * (barWidth + gap),
        size.height - height,
        barWidth,
        height,
      );
      canvas.drawRect(
        rect,
        Paint()..color = i < level ? activeColor : inactiveColor,
      );
    }
  }

  @override
  bool shouldRepaint(SignalBarsPainter old) =>
      old.level != level ||
      old.activeColor != activeColor ||
      old.inactiveColor != inactiveColor ||
      old.bars != bars;
}

/// Hacia dónde "mira" el semicírculo (lado curvo).
enum HalfFacing { up, down, left, right }

/// Semicírculo relleno que ocupa todo el rectángulo disponible.
class HalfDiscPainter extends CustomPainter {
  const HalfDiscPainter({required this.color, this.facing = HalfFacing.up});

  final Color color;
  final HalfFacing facing;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final Rect rect;
    final double start;
    switch (facing) {
      case HalfFacing.up: // cúpula, base plana abajo
        rect = Rect.fromLTWH(0, 0, w, h * 2);
        start = math.pi;
      case HalfFacing.down: // cuenco, base plana arriba
        rect = Rect.fromLTWH(0, -h, w, h * 2);
        start = 0;
      case HalfFacing.left: // curva a la izquierda
        rect = Rect.fromLTWH(0, 0, w * 2, h);
        start = math.pi / 2;
      case HalfFacing.right: // curva a la derecha
        rect = Rect.fromLTWH(-w, 0, w * 2, h);
        start = -math.pi / 2;
    }

    final path = Path()
      ..addArc(rect, start, math.pi)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(HalfDiscPainter old) =>
      old.color != color || old.facing != facing;
}
