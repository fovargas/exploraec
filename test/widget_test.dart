import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exploraec/main.dart';

void main() {
  testWidgets('Inicio muestra la lista de lugares de ejemplo', (WidgetTester tester) async {
    await tester.pumpWidget(const ExploraEcApp());

    expect(find.text('ExploraEC'), findsOneWidget);
    expect(find.text('Parque El Ejido'), findsOneWidget);
  });

  testWidgets('La barra inferior cambia de pestaña', (WidgetTester tester) async {
    await tester.pumpWidget(const ExploraEcApp());

    await tester.tap(find.byIcon(Icons.map));
    await tester.pump();
    expect(find.text('Próximamente: mapa real (Sesión 4)'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();
    expect(find.text('Próximamente: favoritos (Sesión 7)'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home));
    await tester.pump();
    expect(find.text('Parque El Ejido'), findsOneWidget);
  });

  testWidgets('Tocar una tarjeta abre el detalle', (WidgetTester tester) async {
    await tester.pumpWidget(const ExploraEcApp());

    await tester.tap(find.text('Parque El Ejido'));
    await tester.pumpAndSettle();

    expect(find.byType(BackButton), findsOneWidget);
  });
}
