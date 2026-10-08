import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingsService {
  SettingsService._();

  static const _nombreCaja = 'ajustes';
  static const _claveIdioma = 'idioma';

  static const _es = Locale('es', 'EC');
  static const _en = Locale('en', 'US');

  static Future<void> abrir() => Hive.openBox(_nombreCaja);

  static Locale get idioma {
    final guardado = Hive.box(_nombreCaja).get(_claveIdioma, defaultValue: 'es');
    return guardado == 'en' ? _en : _es;
  }

  static void alternarIdioma() {
    final nuevo = Get.locale?.languageCode == 'es' ? _en : _es;
    Get.updateLocale(nuevo);
    Hive.box(_nombreCaja).put(_claveIdioma, nuevo.languageCode);
  }
}
