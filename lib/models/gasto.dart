class Gasto {
  final int id;
  final String descripcion;
  final double monto;
  final String categoria;
  final String fecha;

  const Gasto({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.categoria,
    required this.fecha,
  });

  // `monto` puede llegar como entero o decimal.
  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      descripcion: (json['descripcion'] as String?) ?? 'Sin descripción',
      monto: (json['monto'] as num?)?.toDouble() ?? 0,
      categoria: (json['categoria'] as String?) ?? 'otros',
      fecha: (json['fecha'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'descripcion': descripcion,
        'monto': monto,
        'categoria': categoria,
        'fecha': fecha,
      };

  // Hive devuelve `Map<dynamic, dynamic>`.
  factory Gasto.fromMap(Map mapa) => Gasto.fromJson(Map<String, dynamic>.from(mapa));
}
