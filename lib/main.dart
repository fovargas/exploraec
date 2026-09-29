import 'package:exploraec/bienvenida_claude_design.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colores del sistema de diseño "Equatorial Discovery" (Stitch).
const colorFondo = Color(0xFFFAFAF9);
const colorPrimario = Color(0xFF059669);
const colorPrimarioSuave = Color(0xFFECFDF5);
const colorTexto = Color(0xFF0F172A);
const colorTextoSecundario = Color(0xFF3D4A42);

void main() {
  runApp(const BienvenidaScreenClaudeDesign());
}

class ExploraEcApp extends StatelessWidget {
  const ExploraEcApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExploraEC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorPrimario,
          primary: colorPrimario,
          surface: colorFondo,
        ),
        scaffoldBackgroundColor: colorFondo,
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      ),
      home: const BienvenidaScreen(),
    );
  }
}

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: colorPrimarioSuave,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.explore_outlined,
                        size: 44,
                        color: colorPrimario,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Text(
                      'ExploraEC',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        height: 48 / 40,
                        letterSpacing: -1.2,
                        color: colorTexto,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Descubre y guarda lugares cerca de ti',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        height: 26 / 16,
                        color: colorTextoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimario,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: const StadiumBorder(),
                    elevation: 0,
                    textStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Empezar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
