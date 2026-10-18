import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Fondo cinematográfico local de Valdoria RP. La imagen se incluye en el APK,
/// con movimiento parallax suave y capas oscuras para mantener legibles los paneles.
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
    duration: const Duration(seconds: 48),
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
                // Escena costera original empaquetada localmente: no depende de
                // conexiones externas y se muestra también sin conexión.
                AnimatedBuilder(
                  animation: _motion,
                  builder: (context, _) {
                    final drift = math.sin(_motion.value * math.pi * 2) * 4;
                    final parallax = Offset(
                      (0.5 - _pointer.dx) * 14 + drift,
                      (0.5 - _pointer.dy) * 10,
                    );
                    return Transform.scale(
                      scale: 1.07,
                      child: Transform.translate(
                        offset: parallax,
                        child: Image.asset(
                          'assets/images/valdoria_coast.jpg',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) =>
                              const ColoredBox(color: Color(0xFF101A2A)),
                        ),
                      ),
                    );
                  },
                ),
                // Vignette cinematográfica: el centro conserva el paisaje y los
                // laterales/fondo protegen el contraste de los textos.
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xC90A1220),
                        Color(0x67101B2B),
                        Color(0x18101B2B),
                        Color(0x5C0D1220),
                      ],
                      stops: [0, 0.30, 0.68, 1],
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x4D0D1220),
                        Color(0x100D1220),
                        Color(0xB80D1220),
                      ],
                      stops: [0, 0.44, 1],
                    ),
                  ),
                ),
                // Sutil brillo heráldico en el borde, sin competir con el fondo.
                const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x00D5AD55),
                            Color(0xB8D5AD55),
                            Color(0x00D5AD55),
                          ],
                        ),
                      ),
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
