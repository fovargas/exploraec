class Usuario {
  final int id;
  final String email;
  const Usuario({required this.id, required this.email});

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: (json['id'] as num).toInt(),
        email: json['email'] as String,
      );
}
