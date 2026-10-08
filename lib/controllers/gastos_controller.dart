import 'package:get/get.dart';

import '../models/gasto.dart';
import '../repositories/gastos_repository.dart';
import '../services/api_exception.dart';
import '../services/gastos_api_service.dart';
import 'places_controller.dart' show EstadoCarga;

class GastosController extends GetxController {
  static const int _tamanoPagina = 20;

  final GastosApiService _api = GastosApiService();
  late final GastosRepository _repository = GastosRepository(_api);

  final RxList<Gasto> gastos = <Gasto>[].obs;
  final Rx<EstadoCarga> estado = EstadoCarga.exito.obs;
  final RxString mensajeError = ''.obs;
  final RxInt totalEnServidor = 0.obs;

  // true cuando la última carga vino de la caché local.
  final RxBool desdeCache = false.obs;
  String get ultimaSincronizacion => _repository.ultimaSincronizacion;

  final RxBool sesionActiva = false.obs;
  final RxBool autenticando = false.obs;
  final RxString mensajeAuth = ''.obs;

  bool get hayMas => gastos.length < totalEnServidor.value;

  Future<void> entrar(String email, String password) async {
    autenticando.value = true;
    mensajeAuth.value = '';
    try {
      try {
        await _api.registrar(email, password);
      } on ApiException catch (e) {
        // 400 = el correo ya existe: se sigue al login.
        if (e.statusCode != 400) rethrow;
      }
      await _api.login(email, password);
      await _repository.abrirParaUsuario();
      sesionActiva.value = true;
      await cargarGastos();
    } on ApiException catch (e) {
      mensajeAuth.value = e.mensaje;
    } catch (e) {
      mensajeAuth.value = 'Error inesperado: $e';
    } finally {
      autenticando.value = false;
    }
  }

  Future<void> cargarGastos() async {
    estado.value = EstadoCarga.cargando;
    try {
      final (lista, cache) = await _repository.obtenerGastos();
      gastos.value = lista;
      totalEnServidor.value = lista.length;
      desdeCache.value = cache;
      estado.value = EstadoCarga.exito;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        sesionActiva.value = false; // volver al formulario
        mensajeAuth.value = e.mensaje;
      }
      mensajeError.value = e.mensaje;
      estado.value = EstadoCarga.error;
    } catch (e) {
      mensajeError.value = 'Error inesperado: $e';
      estado.value = EstadoCarga.error;
    }
  }

  Future<void> cargarMas() async {
    if (!hayMas) return;
    try {
      final r = await _api.listarGastos(skip: gastos.length, limit: _tamanoPagina);
      gastos.addAll(r.gastos);
      totalEnServidor.value = r.total;
    } on ApiException catch (e) {
      Get.snackbar('No se pudo cargar más', e.mensaje);
    }
  }

  // Hive guarda sin cifrar: la caja del usuario se borra al salir.
  Future<void> salir() async {
    _api.cerrarSesion();
    await _repository.vaciar();
    gastos.clear();
    totalEnServidor.value = 0;
    desdeCache.value = false;
    estado.value = EstadoCarga.exito;
    sesionActiva.value = false;
  }

  void invalidarTokenParaPruebas() => _api.invalidarTokenParaPruebas();
}
