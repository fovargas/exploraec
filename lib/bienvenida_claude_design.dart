import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Paleta del sistema de diseño "Equatorial Discovery" (Stitch).
const _surface = Color(0xFFFAF8FF);
const _surfaceLowest = Color(0xFFFFFFFF);
const _onSurface = Color(0xFF131B2E);
const _onSurfaceVariant = Color(0xFF3D4A42);
const _primary = Color(0xFF006948);
const _primaryContainer = Color(0xFF00855D);
const _primaryFixed = Color(0xFF85F8C4);
const _onPrimaryFixedVariant = Color(0xFF005137);
const _secondary = Color(0xFF006A61);
const _secondaryFixed = Color(0xFF89F5E7);
const _secondaryContainer = Color(0xFF86F2E4);
const _outlineVariant = Color(0xFFBCCAC0);

TextStyle _jakarta({
  required double size,
  FontWeight weight = FontWeight.w400,
  double? height,
  double letterSpacing = 0,
  Color color = _onSurface,
}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
  );
}

class BienvenidaScreenClaudeDesign extends StatelessWidget {
  const BienvenidaScreenClaudeDesign({
    super.key,
    this.onEmpezar,
    this.onOmitir,
    this.onCerrar,
    this.onTerminos,
    this.onPrivacidad,
  });

  final VoidCallback? onEmpezar;
  final VoidCallback? onOmitir;
  final VoidCallback? onCerrar;
  final VoidCallback? onTerminos;
  final VoidCallback? onPrivacidad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Stack(
        children: [
          // Resplandores ambientales difuminados.
          const Positioned(
            top: -96,
            left: -80,
            child: _Resplandor(
              tamano: 320,
              color: _secondaryFixed,
              opacidad: 0.18,
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height / 2,
            right: -112,
            child: const _Resplandor(
              tamano: 288,
              color: _primaryFixed,
              opacidad: 0.13,
            ),
          ),
          Positioned(
            bottom: -64,
            left: MediaQuery.sizeOf(context).width / 4,
            child: const _Resplandor(
              tamano: 320,
              color: _secondaryContainer,
              opacidad: 0.08,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _BarraSuperior(onCerrar: onCerrar, onOmitir: onOmitir),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, -16),
                    child: const _BloqueCentral(),
                  ),
                ),
                _BloqueInferior(
                  onEmpezar: onEmpezar,
                  onTerminos: onTerminos,
                  onPrivacidad: onPrivacidad,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Resplandor extends StatelessWidget {
  const _Resplandor({
    required this.tamano,
    required this.color,
    required this.opacidad,
  });

  final double tamano;
  final Color color;
  final double opacidad;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacidad),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarraSuperior extends StatelessWidget {
  const _BarraSuperior({this.onCerrar, this.onOmitir});

  final VoidCallback? onCerrar;
  final VoidCallback? onOmitir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onCerrar,
            tooltip: 'Cerrar',
            icon: const Icon(Icons.close, size: 22, color: _onSurfaceVariant),
          ),
          Text(
            'ExploraEC',
            style: _jakarta(
              size: 20,
              weight: FontWeight.w700,
              height: 28 / 20,
              letterSpacing: -0.5,
            ),
          ),
          TextButton(
            onPressed: onOmitir,
            style: TextButton.styleFrom(foregroundColor: _primary),
            child: Text(
              'Omitir',
              style: _jakarta(
                size: 14,
                weight: FontWeight.w600,
                height: 20 / 14,
                letterSpacing: 0.14,
                color: _primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BloqueCentral extends StatelessWidget {
  const _BloqueCentral();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _Emblema(),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 310),
            child: Column(
              children: [
                const _InsigniaRegion(),
                const SizedBox(height: 12),
                Text(
                  'ExploraEC',
                  textAlign: TextAlign.center,
                  style: _jakarta(
                    size: 26,
                    weight: FontWeight.w700,
                    height: 34 / 26,
                    letterSpacing: -0.65,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Descubre lugares increíbles cerca de ti',
                  textAlign: TextAlign.center,
                  style: _jakarta(
                    size: 14,
                    height: 1.625,
                    letterSpacing: 0.07,
                    color: _onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const _IndicadorPasos(),
        ],
      ),
    );
  }
}

class _Emblema extends StatelessWidget {
  const _Emblema();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Aura suave.
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _secondaryContainer.withValues(alpha: 0.4),
                  _secondaryContainer.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          // Anillo concéntrico con degradado.
          Container(
            width: 112,
            height: 112,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _surfaceLowest,
                  _secondaryFixed.withValues(alpha: 0.4),
                  _primaryFixed.withValues(alpha: 0.3),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.12),
                  offset: const Offset(0, 12),
                  blurRadius: 32,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _surfaceLowest,
              ),
              alignment: Alignment.center,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primaryContainer.withValues(alpha: 0.1),
                ),
                child: const Icon(Icons.explore, size: 38, color: _primary),
              ),
            ),
          ),
          // Coordenada de latitud cero.
          Positioned(
            bottom: -2,
            right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: _surfaceLowest,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: _secondaryFixed),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '0° 0\' 0"',
                    style: _jakarta(
                      size: 10,
                      weight: FontWeight.w700,
                      height: 14 / 10,
                      letterSpacing: 1,
                      color: _secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsigniaRegion extends StatelessWidget {
  const _InsigniaRegion();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _primaryFixed.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.nature, size: 13, color: _primary),
          const SizedBox(width: 6),
          Text(
            'ECUADOR TE ESPERA',
            style: _jakarta(
              size: 10,
              weight: FontWeight.w700,
              height: 14 / 10,
              letterSpacing: 0.5,
              color: _onPrimaryFixedVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicadorPasos extends StatelessWidget {
  const _IndicadorPasos();

  @override
  Widget build(BuildContext context) {
    Widget punto({required bool activo}) {
      return Container(
        width: activo ? 24 : 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: activo ? _primary : _outlineVariant.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(999),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        punto(activo: true),
        punto(activo: false),
        punto(activo: false),
      ],
    );
  }
}

class _BloqueInferior extends StatelessWidget {
  const _BloqueInferior({this.onEmpezar, this.onTerminos, this.onPrivacidad});

  final VoidCallback? onEmpezar;
  final VoidCallback? onTerminos;
  final VoidCallback? onPrivacidad;

  @override
  Widget build(BuildContext context) {
    final estiloNota = _jakarta(
      size: 12,
      height: 18 / 12,
      color: _onSurfaceVariant.withValues(alpha: 0.7),
    );
    final estiloEnlace = estiloNota.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: estiloNota.color,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.38),
                  offset: const Offset(0, 10),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onEmpezar ?? () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  overlayColor: _primaryContainer,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Empezar',
                      style: _jakarta(
                        size: 14,
                        weight: FontWeight.w600,
                        height: 20 / 14,
                        letterSpacing: 0.35,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text('Al continuar, aceptas nuestros ', style: estiloNota),
              GestureDetector(
                onTap: onTerminos,
                child: Text('Términos', style: estiloEnlace),
              ),
              Text(' y ', style: estiloNota),
              GestureDetector(
                onTap: onPrivacidad,
                child: Text('Privacidad', style: estiloEnlace),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
