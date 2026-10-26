import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:exploraec/controllers/auth_controller.dart';
import 'package:exploraec/controllers/gastos_controller.dart';
import 'package:exploraec/controllers/places_controller.dart' show EstadoCarga;
import 'package:exploraec/screens/gastos_screen.dart';
import 'package:exploraec/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

/// Servidor falso con tres gastos: dos de comida y uno de transporte.
class _Servidor implements HttpClientAdapter {
  ResponseBody _json(Object cuerpo) => ResponseBody.fromString(jsonEncode(cuerpo), 200,
      headers: {Headers.contentTypeHeader: ['application/json']});

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? cuerpo, Future<void>? cancelar) async {
    switch (o.path) {
      case '/usuarios/me':
        return _json({'id': 1, 'email': 'a@b.com'});
      case '/gastos/categorias':
        return _json({'categorias': ['comida', 'transporte', 'otros'], 'limite_por_categoria': 500.0});
      case '/gastos/':
        return _json([
          {'id': 1, 'descripcion': 'Almuerzo', 'monto': 8.5, 'categoria': 'comida', 'fecha': '2026-10-14'},
          {'id': 2, 'descripcion': 'Taxi', 'monto': 4, 'categoria': 'transporte', 'fecha': '2026-10-14'},
          {'id': 3, 'descripcion': 'Cena', 'monto': 12, 'categoria': 'comida', 'fecha': '2026-10-14'},
        ]);
    }
    return ResponseBody.fromString('{"detail": "no previsto"}', 404,
        headers: {Headers.contentTypeHeader: ['application/json']});
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() => Hive.init(Directory.systemTemp.createTempSync('hive_filtro').path));

  tearDown(() async {
    Get.reset();
    await Hive.close();
  });

  testWidgets('Al elegir «comida» solo se ven los gastos de comida', (tester) async {
    await tester.runAsync(() async {
      Get.reset();
      Get.testMode = true;
      FlutterSecureStorage.setMockInitialValues({'access_token': 'tok-a@b.com'});
      // Caja en memoria: con disco real se cuelga en el reloj simulado.
      await Hive.openBox('gastos_1', bytes: Uint8List(0));
      Get.put(ApiClient(dio: Dio(BaseOptions(baseUrl: 'http://prueba'))..httpClientAdapter = _Servidor()));
      await Get.put(AuthController()).restaurarSesion();
      final gastos = Get.put(GastosController());
      for (var i = 0; i < 200 && (gastos.estado.value != EstadoCarga.exito || gastos.gastos.isEmpty); i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });

    await tester.pumpWidget(const GetMaterialApp(home: GastosScreen()));
    await tester.pump();

    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Taxi'), findsOneWidget);
    expect(find.text('Cena'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'comida'));
    await tester.pump();

    expect(find.text('Almuerzo'), findsOneWidget);
    expect(find.text('Cena'), findsOneWidget);
    expect(find.text('Taxi'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Todas'));
    await tester.pump();

    expect(find.text('Taxi'), findsOneWidget);
    expect(find.text('Almuerzo'), findsOneWidget);
  });
}
