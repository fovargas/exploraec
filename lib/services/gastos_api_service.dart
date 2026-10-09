import '../models/gasto.dart';
import 'api_client.dart';

class GastosApiService {
  GastosApiService(this._client);

  final ApiClient _client;

  // El id da nombre a la caja de Hive de cada usuario (`gastos_<id>`).
  Future<int> obtenerIdUsuario() async {
    final r = await _client.get('/usuarios/me');
    final id = r.data is Map ? (r.data as Map)['id'] : null;
    if (id is! int) {
      throw ApiException('Respuesta inesperada del servidor al leer tu perfil.');
    }
    return id;
  }

  // La barra final importa: sin ella el servidor responde 307.
  Future<({List<Gasto> gastos, int total})> listarGastos({int skip = 0, int limit = 20}) async {
    final r = await _client.get('/gastos/', query: {'skip': skip, 'limit': limit});
    final json = r.data;
    if (json is! List) {
      throw ApiException('Respuesta inesperada del servidor al listar gastos.');
    }
    final gastos = json.whereType<Map<String, dynamic>>().map(Gasto.fromJson).toList();
    final total = int.tryParse(r.headers.value('x-total-count') ?? '') ?? gastos.length;
    return (gastos: gastos, total: total);
  }

  Future<({List<String> categorias, double limite})> listarCategorias() async {
    final r = await _client.get('/gastos/categorias');
    final json = r.data;
    if (json is! Map || json['categorias'] is! List) {
      throw ApiException('Respuesta inesperada del servidor al leer las categorías.');
    }
    return (
      categorias: (json['categorias'] as List).map((c) => '$c').toList(),
      limite: (json['limite_por_categoria'] as num?)?.toDouble() ?? 500,
    );
  }

  Future<Gasto> crear(Map<String, dynamic> datos) async {
    final r = await _client.post('/gastos/', data: datos);
    return Gasto.fromJson(Map<String, dynamic>.from(r.data as Map));
  }

  Future<Gasto> actualizar(int id, Map<String, dynamic> cambios) async {
    final r = await _client.patch('/gastos/$id', data: cambios);
    return Gasto.fromJson(Map<String, dynamic>.from(r.data as Map));
  }

  Future<void> eliminar(int id) async {
    await _client.delete('/gastos/$id');
  }
}
