class Validadores {
  Validadores._();

  static String? correo(String? valor) {
    final texto = valor?.trim() ?? '';
    final ok = texto.contains('@') && texto.contains('.');
    return ok ? null : 'Escribe un correo válido';
  }

  static String? password(String? valor) {
    final largo = valor?.length ?? 0;
    return (largo >= 8 && largo <= 72) ? null : 'La contraseña debe tener entre 8 y 72 caracteres';
  }
}
