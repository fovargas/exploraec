import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:exploraec/main.dart';
import 'package:exploraec/models/place.dart';

void main() {
  final lugaresIniciales = List.of(lugaresEjemplo);

  tearDown(() {
    Get.reset();
    lugaresEjemplo
      ..clear()
      ..addAll(lugaresIniciales);
  });

  Future<void> abrirApp(WidgetTester tester) async {
    await tester.pumpWidget(const ExploraEcApp());
    await tester.pumpAndSettle();
  }

  Future<void> simular(WidgetTester tester, String opcion) async {
    await tester.tap(find.byTooltip('Simular estado (solo práctica)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(opcion));
    await tester.pumpAndSettle();
  }

  testWidgets('Inicio muestra la carga y luego la lista con el total', (tester) async {
    await tester.pumpWidget(const ExploraEcApp());
    expect(find.text('Buscando lugares cercanos...'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('ExploraEC (6)'), findsOneWidget);
    expect(find.text('Parque El Ejido'), findsOneWidget);
  });

  testWidgets('El menú simula los estados vacío y error', (tester) async {
    await abrirApp(tester);

    await simular(tester, 'Simular: vacío');
    expect(find.text('Todavía no hay lugares guardados'), findsOneWidget);

    await simular(tester, 'Simular: error');
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.text('Error'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));

    await simular(tester, 'Simular: normal');
    expect(find.text('Parque El Ejido'), findsOneWidget);
  });

  testWidgets('Agregar un lugar lo muestra en Inicio sin recargar', (tester) async {
    await abrirApp(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Mirador de Guápulo');
    await tester.enterText(find.byType(TextFormField).at(1), 'Miradores');
    await tester.enterText(find.byType(TextFormField).at(2), 'Vista del valle de Cumbayá.');
    await tester.tap(find.text('Guardar'));
    await tester.pump();

    expect(find.text('Buscando lugares cercanos...'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('ExploraEC (7)'), findsOneWidget);
    expect(find.text('Lugar agregado'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });

  testWidgets('Los favoritos se comparten con la pestaña Favoritos', (tester) async {
    await abrirApp(tester);

    await tester.tap(find.byTooltip('Agregar a favoritos').first);
    await tester.pump();
    expect(find.byTooltip('Quitar de favoritos'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite).last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Favoritos marcados: 1'), findsOneWidget);
  });

  testWidgets('La barra inferior se traduce al inglés', (tester) async {
    await abrirApp(tester);
    expect(find.text('Inicio'), findsOneWidget);

    // Get.updateLocale fuerza un reassemble que choca con el binding de test.
    Get.locale = const Locale('en', 'US');
    tester.binding.buildOwner!.reassemble(tester.binding.rootElement!);
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
  });

  testWidgets('La tarjeta expone un label accesible y abre el detalle', (tester) async {
    await abrirApp(tester);

    final tarjeta = find.bySemanticsLabel('Parque El Ejido, categoría Parques');
    expect(tarjeta, findsOneWidget);

    await tester.tap(tarjeta);
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
  });

  for (final ancho in [620.0, 920.0]) {
    testWidgets('A ${ancho.toInt()} px Inicio usa una grilla sin overflow', (tester) async {
      tester.view.physicalSize = Size(ancho, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await abrirApp(tester);

      expect(find.byType(GridView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
