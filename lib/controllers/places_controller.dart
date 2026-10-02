import 'package:get/get.dart';

import '../models/place.dart';

enum EstadoCarga { cargando, exito, error }

class PlacesController extends GetxController {
  final RxList<Place> lugares = <Place>[].obs;
  final Rx<EstadoCarga> estado = EstadoCarga.cargando.obs;
  final RxString mensajeError = ''.obs;
  final RxList<Place> favoritos = <Place>[].obs;

  bool _modoDebugError = false;
  bool _modoDebugVacio = false;

  @override
  void onInit() {
    super.onInit();
    ever(estado, (EstadoCarga e) {
      if (e == EstadoCarga.error) {
        Get.snackbar('Error', mensajeError.value);
      }
    });
    cargarLugares();
  }

  void simular(String modo) {
    _modoDebugError = modo == 'error';
    _modoDebugVacio = modo == 'vacio';
    cargarLugares();
  }

  Future<void> cargarLugares() async {
    estado.value = EstadoCarga.cargando;
    try {
      final resultado = await fetchLugaresSimulado(
        forzarError: _modoDebugError,
        forzarVacio: _modoDebugVacio,
      );
      // assignAll copia los elementos: así `lugares` no es la misma lista que `lugaresEjemplo`.
      lugares.assignAll(resultado);
      estado.value = EstadoCarga.exito;
    } catch (e) {
      mensajeError.value = '$e';
      estado.value = EstadoCarga.error;
    }
  }

  void agregarLugar(Place lugar) {
    lugaresEjemplo.add(lugar);
    lugares.add(lugar);
  }

  bool esFavorito(Place lugar) => favoritos.any((p) => p.id == lugar.id);

  void alternarFavorito(Place lugar) {
    if (esFavorito(lugar)) {
      favoritos.removeWhere((p) => p.id == lugar.id);
    } else {
      favoritos.add(lugar);
    }
  }

  int get total => lugares.length;

  int get totalFavoritos => favoritos.length;
}
