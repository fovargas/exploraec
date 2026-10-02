import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:exploraec/main.dart';

void main() {
  testWidgets('Inicio muestra la carga y luego la lista de lugares', (WidgetTester tester) async {
    await tester.pumpWidget(const ExploraEcApp());

    expect(find.text('Buscando lugares cercanos...'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('ExploraEC'), findsOneWidget);
    expect(find.text('Parque El Ejido'), findsOneWidget);
  });

  testWidgets('El menú simula los estados vacío y error', (WidgetTester tester) async {
    await tester.pumpWidget(const ExploraEcApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Simular estado (solo práctica)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simular: vacío'));
    await tester.pumpAndSettle();
    expect(find.text('Todavía no hay lugares guardados'), findsOneWidget);

    await tester.tap(find.byTooltip('Simular estado (solo práctica)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simular: error'));
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsOneWidget);

    await tester.tap(find.byTooltip('Simular estado (solo práctica)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simular: normal'));
    await tester.pumpAndSettle();
    expect(find.text('Parque El Ejido'), findsOneWidget);
  });

  testWidgets('La barra inferior cambia de pestaña', (WidgetTester tester) async {
    await tester.pumpWidget(const ExploraEcApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.map));
    await tester.pump();
    expect(find.textContaining('Próximamente'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();
    expect(find.textContaining('Próximamente'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('Parque El Ejido'), findsOneWidget);
  });

  testWidgets('La tarjeta expone un label accesible y abre el detalle', (WidgetTester tester) async {
    await tester.pumpWidget(const ExploraEcApp());
    await tester.pumpAndSettle();

    final tarjeta = find.bySemanticsLabel('Parque El Ejido, categoría Parques');
    expect(tarjeta, findsOneWidget);

    await tester.tap(tarjeta);
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
  });

  // Justo después de 600 y 900 px las celdas son las más angostas de cada
  // rango: es donde aparecería un RenderFlex overflow.
  for (final ancho in [620.0, 920.0]) {
    testWidgets('A ${ancho.toInt()} px Inicio usa una grilla sin overflow', (WidgetTester tester) async {
      tester.view.physicalSize = Size(ancho, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const ExploraEcApp());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
