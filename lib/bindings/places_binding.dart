import 'package:get/get.dart';

import '../controllers/gastos_controller.dart';
import '../controllers/places_controller.dart';

class PlacesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlacesController());
    Get.lazyPut(() => GastosController());
  }
}
