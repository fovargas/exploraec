import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/places_binding.dart';
import 'i18n/app_translations.dart';
import 'screens/home_screen.dart';
import 'screens/map_placeholder_screen.dart';
import 'screens/favorites_placeholder_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ExploraEcApp());
}

class ExploraEcApp extends StatelessWidget {
  const ExploraEcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ExploraEC',
      theme: AppTheme.theme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      translations: AppTranslations(),
      locale: const Locale('es', 'EC'),
      fallbackLocale: const Locale('es', 'EC'),
      initialBinding: PlacesBinding(),
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _indiceActual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_indiceActual) {
        0 => const HomeScreen(),
        1 => const MapPlaceholderScreen(),
        _ => const FavoritesPlaceholderScreen(),
      },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (i) => setState(() => _indiceActual = i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'inicio'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.map), label: 'mapa'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: 'favoritos'.tr),
        ],
      ),
    );
  }
}
