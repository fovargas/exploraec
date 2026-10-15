import 'package:flutter/widgets.dart';

/// Falla a propósito (solo práctica, menú de Gastos en modo depuración).
class PantallaConFallo extends StatelessWidget {
  const PantallaConFallo({super.key});

  @override
  Widget build(BuildContext context) {
    throw StateError('Fallo provocado a propósito para la práctica');
  }
}
