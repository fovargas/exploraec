import 'package:get/get.dart';

import '../models/usuario.dart';
import '../services/api_client.dart';
import '../services/secure_token_storage.dart';
import 'gastos_controller.dart';

class AuthController extends GetxController {
  AuthController({ApiClient? api, SecureTokenStorage? almacen})
      : _api = api ?? Get.find<ApiClient>(),
        _almacen = almacen ?? SecureTokenStorage();

  final ApiClient _api;
  final SecureTokenStorage _almacen;

  final Rxn<Usuario> usuario = Rxn<Usuario>();
  final RxBool cargando = false.obs;

  final RxBool restaurando = false.obs;

  final RxString mensajeError = ''.obs;

  final RxString avisoSesion = ''.obs;

  bool get estaAutenticado => usuario.value != null;

  @override
  void onInit() {
    super.onInit();
    _api.alSesionCaducada = sesionCaducada;
    restaurarSesion();
  }

  Future<void> registrar(String email, String password) async {
    cargando.value = true;
    mensajeError.value = '';
    try {
      await _api.post('/usuarios/', data: {'email': email, 'password': password});
      await iniciarSesion(email, password);
    } on ApiException catch (e) {
      mensajeError.value = e.mensaje;
    } finally {
      cargando.value = false;
    }
  }

  // Login OAuth2: va como formulario (no JSON) y `username` lleva el correo.
  Future<void> iniciarSesion(String email, String password) async {
    cargando.value = true;
    mensajeError.value = '';
    try {
      final r = await _api.post(
        '/usuarios/token',
        data: {'username': email, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final token = (r.data as Map)['access_token'] as String;
      _api.token = token;
      await _almacen.guardar(token);
      await cargarUsuario();
      avisoSesion.value = '';
    } on ApiException catch (e) {
      mensajeError.value = e.mensaje;
    } finally {
      cargando.value = false;
    }
  }

  // Un 401 borra el token; sin conexión se conserva (puede seguir siendo válido).
  Future<void> restaurarSesion() async {
    restaurando.value = true;
    try {
      final guardado = await _almacen.leer();
      if (guardado == null) return;
      _api.token = guardado;
      await cargarUsuario();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await cerrarSesion();
        avisoSesion.value = 'Tu sesión caducó, inicia sesión de nuevo.';
      } else {
        avisoSesion.value = e.mensaje;
      }
    } finally {
      restaurando.value = false;
    }
  }

  Future<void> sesionCaducada() async {
    await cerrarSesion();
    avisoSesion.value = 'Tu sesión caducó, inicia sesión de nuevo.';
    // Cierra el formulario si estaba abierto.
    if (Get.key.currentState != null) Get.until((ruta) => ruta.isFirst);
  }

  Future<void> cerrarSesion() async {
    if (Get.isRegistered<GastosController>()) await Get.find<GastosController>().limpiar();
    await _almacen.borrar();
    _api.token = null;
    usuario.value = null;
  }

  Future<void> cambiarPassword(String actual, String nueva) async {
    cargando.value = true;
    mensajeError.value = '';
    try {
      await _api.put('/usuarios/me/password', data: {'password_actual': actual, 'password_nueva': nueva});
      await cerrarSesion();
    } on ApiException catch (e) {
      mensajeError.value = e.mensaje;
    } finally {
      cargando.value = false;
    }
  }

  Future<void> cargarUsuario() async {
    final r = await _api.get('/usuarios/me');
    usuario.value = Usuario.fromJson(Map<String, dynamic>.from(r.data as Map));
  }

  // Solo práctica (Paso 7): fuerza un 401 en la siguiente petición.
  void invalidarTokenParaPruebas() => _api.token = 'token-invalido';
}
