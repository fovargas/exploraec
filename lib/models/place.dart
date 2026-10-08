class Place {
  final String id;
  final String nombre;
  final String categoria;
  final String descripcion;
  final double lat;
  final double lng;

  Place({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.descripcion,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'categoria': categoria,
        'descripcion': descripcion,
        'lat': lat,
        'lng': lng,
      };

  factory Place.fromMap(Map<String, dynamic> mapa) => Place(
        id: mapa['id'] as String,
        nombre: mapa['nombre'] as String,
        categoria: mapa['categoria'] as String,
        descripcion: mapa['descripcion'] as String,
        lat: (mapa['lat'] as num).toDouble(),
        lng: (mapa['lng'] as num).toDouble(),
      );
}

final List<Place> lugaresEjemplo = [
  Place(
    id: '1',
    nombre: 'Parque El Ejido',
    categoria: 'Parques',
    descripcion: 'Parque urbano en el centro-norte de Quito, con ferias de arte los fines de semana.',
    lat: -0.2073,
    lng: -78.4900,
  ),
  Place(
    id: '2',
    nombre: 'Café Galletti',
    categoria: 'Cafeterías',
    descripcion: 'Cafetería de especialidad con opciones de trabajo remoto y buen wifi.',
    lat: -0.1938,
    lng: -78.4869,
  ),
  Place(
    id: '3',
    nombre: 'Museo Casa del Alabado',
    categoria: 'Museos',
    descripcion: 'Museo de arte precolombino en el Centro Histórico de Quito.',
    lat: -0.2201,
    lng: -78.5125,
  ),
  Place(
    id: '4',
    nombre: 'Mercado Central',
    categoria: 'Restaurantes',
    descripcion: 'Mercado tradicional con puestos de comida típica ecuatoriana.',
    lat: -0.2185,
    lng: -78.5110,
  ),
  Place(
    id: '5',
    nombre: 'Parque La Carolina',
    categoria: 'Parques',
    descripcion: 'Parque metropolitano con jardín botánico, canchas deportivas y lago para botes.',
    lat: -0.1807,
    lng: -78.4859,
  ),
  Place(
    id: '6',
    nombre: 'Vista Hermosa',
    categoria: 'Restaurantes',
    descripcion: 'Restaurante con terraza y vista panorámica del Centro Histórico.',
    lat: -0.2199,
    lng: -78.5122,
  ),
];

/// Simula una llamada de red. forzarError/forzarVacio permiten probar los estados de error y vacío.
Future<List<Place>> fetchLugaresSimulado({bool forzarError = false, bool forzarVacio = false}) async {
  await Future.delayed(const Duration(seconds: 1));
  if (forzarError) {
    throw Exception('No se pudo conectar con el servidor (simulado)');
  }
  return forzarVacio ? <Place>[] : lugaresEjemplo;
}
