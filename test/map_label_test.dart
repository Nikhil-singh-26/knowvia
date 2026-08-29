import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:know_via/features/map/presentation/screens/map_screen.dart';

void main() {
  testWidgets(
    'MapNodeLabel keeps long concept labels readable and non-overflowing',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MapNodeLabel(
                label: 'Extremely long concept name that should shrink cleanly',
                isConcept: true,
              ),
            ),
          ),
        ),
      );

      expect(
        find.text('Extremely long concept name that should shrink cleanly'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
