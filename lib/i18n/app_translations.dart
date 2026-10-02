import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'es_EC': {
          'inicio': 'Inicio',
          'mapa': 'Mapa',
          'favoritos': 'Favoritos',
          'idioma': 'Cambiar idioma',
          'sim_normal': 'Simular: normal',
          'sim_vacio': 'Simular: vacío',
          'sim_error': 'Simular: error',
          'agregar_lugar': 'Agregar lugar',
          'nombre_lugar': 'Nombre del lugar',
          'categoria': 'Categoría',
          'descripcion': 'Descripción',
          'guardar': 'Guardar',
          'lugar_agregado': 'Lugar agregado',
          'lugar_agregado_msg': 'Ya aparece en Inicio',
        },
        'en_US': {
          'inicio': 'Home',
          'mapa': 'Map',
          'favoritos': 'Favorites',
          'idioma': 'Change language',
          'sim_normal': 'Simulate: normal',
          'sim_vacio': 'Simulate: empty',
          'sim_error': 'Simulate: error',
          'agregar_lugar': 'Add place',
          'nombre_lugar': 'Place name',
          'categoria': 'Category',
          'descripcion': 'Description',
          'guardar': 'Save',
          'lugar_agregado': 'Place added',
          'lugar_agregado_msg': 'It now shows up on Home',
        },
      };
}
