import 'package:hive/hive.dart';

import '../models/gasto.dart';
import '../services/api_exception.dart';
import '../services/gastos_api_service.dart';

// Servidor primero; si falla por red o 5xx, devuelve la copia guardada en Hive.
// Un 401 o 4xx no usa la caché: no es una falla de infraestructura.
class GastosRepository {
  GastosRepository(this._api);

  final GastosApiService _api;
  Box? _caja;

  static const _claveGastos = 'gastos';
  static const _claveSincronizado = 'sincronizado';

  Future<void> abrirParaUsuario() async {
    final id = await _api.obtenerIdUsuario();
    _caja = await Hive.openBox('gastos_$id');
  }

  // El bool indica si la lista viene de la caché.
  Future<(List<Gasto>, bool)> obtenerGastos() async {
    try {
      // 100 es el máximo del backend; la caché no se pagina.
      final resultado = await _api.listarGastos(limit: 100);
      await _guardar(resultado.gastos);
      return (resultado.gastos, false);
    } on ApiException catch (e) {
      final fallaDeInfraestructura = e.statusCode == null || e.statusCode! >= 500;
      if (!fallaDeInfraestructura) rethrow;
      final guardados = _leer();
      if (guardados == null) rethrow;
      return (guardados, true);
    }
  }

  String get ultimaSincronizacion {
    final iso = _caja?.get(_claveSincronizado) as String?;
    final fecha = iso == null ? null : DateTime.tryParse(iso)?.toLocal();
    if (fecha == null) return 'desconocida';
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(fecha.day)}/${dos(fecha.month)} ${dos(fecha.hour)}:${dos(fecha.minute)}';
  }

  Future<void> vaciar() async {
    await _caja?.deleteFromDisk();
    _caja = null;
  }

  Future<void> _guardar(List<Gasto> gastos) async {
    final caja = _caja;
    if (caja == null) return;
    // Reemplaza la copia anterior para no arrastrar gastos borrados.
    await caja.put(_claveGastos, gastos.map((g) => g.toMap()).toList());
    await caja.put(_claveSincronizado, DateTime.now().toIso8601String());
  }

  List<Gasto>? _leer() {
    // Un 401 cierra la sesión (y la caja) mientras esta lectura sigue en marcha.
    final caja = _caja;
    if (caja == null || !caja.isOpen) return null;
    final guardado = caja.get(_claveGastos);
    if (guardado is! List) return null;
    return guardado.map((m) => Gasto.fromMap(m as Map)).toList();
  }
}
