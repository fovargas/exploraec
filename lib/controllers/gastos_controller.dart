import 'package:get/get.dart';

import '../models/gasto.dart';
import '../repositories/gastos_repository.dart';
import '../services/api_client.dart';
import '../services/gastos_api_service.dart';
import 'auth_controller.dart';
import 'places_controller.dart' show EstadoCarga;

class GastosController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  late final GastosApiService _api = GastosApiService(Get.find<ApiClient>());
  late final GastosRepository _repository = GastosRepository(_api);

  final RxList<Gasto> gastos = <Gasto>[].obs;
  final Rx<EstadoCarga> estado = EstadoCarga.exito.obs;
  final RxString mensajeError = ''.obs;
  final RxInt totalEnServidor = 0.obs;

  final RxList<String> categorias = <String>[].obs;

  // true cuando la última carga vino de la caché local.
  final RxBool desdeCache = false.obs;
  String get ultimaSincronizacion => _repository.ultimaSincronizacion;

  @override
  void onInit() {
    super.onInit();
    // Carga los datos en cuanto hay usuario (login, registro o sesión restaurada).
    ever(_auth.usuario, (u) {
      if (u != null) iniciar();
    });
    if (_auth.estaAutenticado) iniciar();
  }

  Future<void> iniciar() async {
    estado.value = EstadoCarga.cargando;
    try {
      await _repository.abrirParaUsuario();
      await cargarCategorias();
    } on ApiException catch (e) {
      mensajeError.value = e.mensaje;
      estado.value = EstadoCarga.error;
      return;
    }
    await cargarGastos();
  }

  Future<void> cargarGastos() async {
    estado.value = EstadoCarga.cargando;
    try {
      await _refrescar();
      estado.value = EstadoCarga.exito;
    } on ApiException catch (e) {
      mensajeError.value = e.mensaje;
      estado.value = EstadoCarga.error;
    }
  }

  // Sin pasar por «cargando», para que la lista no parpadee tras crear/editar/eliminar.
  Future<void> _refrescar() async {
    final (lista, cache) = await _repository.obtenerGastos();
    gastos.value = lista;
    totalEnServidor.value = lista.length;
    desdeCache.value = cache;
  }

  Future<void> cargarCategorias() async {
    final r = await _api.listarCategorias();
    categorias.assignAll(r.categorias);
  }

  // Si el servidor rechaza el gasto (p. ej. límite de 500) lanza ApiException.
  Future<void> crear(String descripcion, double monto, String categoria) async {
    await _api.crear({'descripcion': descripcion, 'monto': monto, 'categoria': categoria});
    await _refrescar();
  }

  Future<void> actualizar(int id, Map<String, dynamic> cambios) async {
    try {
      await _api.actualizar(id, cambios);
    } on ApiException catch (e) {
      if (e.statusCode == 404) await _refrescar();
      rethrow;
    }
    await _refrescar();
  }

  Future<void> eliminar(int id) async {
    try {
      await _api.eliminar(id);
    } on ApiException catch (e) {
      if (e.statusCode == 404) await _refrescar();
      rethrow;
    }
    await _refrescar();
  }

  // Hive guarda sin cifrar: la caja del usuario se borra al salir.
  Future<void> limpiar() async {
    await _repository.vaciar();
    gastos.clear();
    categorias.clear();
    totalEnServidor.value = 0;
    desdeCache.value = false;
    mensajeError.value = '';
    estado.value = EstadoCarga.exito;
  }
}
