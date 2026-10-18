import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:artplay_launcher/ui/widgets/cinematic_backdrop.dart';

void main() {
  testWidgets('el fondo cinematográfico muestra contenido y recurso local',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CinematicBackdrop(
            child: Center(child: Text('VALDORIA RP')),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 40));

    expect(find.text('VALDORIA RP'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('el fondo se adapta a una ventana compacta', (tester) async {
    tester.view.physicalSize = const Size(640, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CinematicBackdrop(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text('V'),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 40));

    expect(find.text('V'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
