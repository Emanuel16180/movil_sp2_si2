import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      // baseUrl: 'http://192.168.252.42:8000/api',
      baseUrl: 'https://ecommercebackend-7m3u.onrender.com/api',
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  /// Método para hacer login y obtener el token JWT
  Future<bool> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        "/token/", 
        data: {
          "email": email,
          "password": password,
        },
      );
      // Imprime la respuesta para debug (podés cambiar por log())
      print("Respuesta login: ${response.data}");
      if (response.statusCode == 200 && response.data["access"] != null) {
        String accessToken = response.data["access"];
        String refreshToken = response.data["refresh"];
        await _saveTokens(accessToken, refreshToken);
        return true;
      }
  } catch (e) {
    // Aquí está el nuevo catch mejorado
    if (e is DioException && e.response != null) {
      print(" Error status: ${e.response?.statusCode}");
      print(" Error data: ${e.response?.data}");
    } else {
      print("Error en login: $e");
    }
  }

  return false;
}

  /// Método para registrar usuario (requiere endpoint sin autenticación previa)
  Future<bool> register(String email, String password) async {
    try {
      Response response = await _dio.post(
        "/users/create/", // Verificá que este endpoint sea público
        data: {
          "email": email,
          "password": password,
        },
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Error en registro: $e");
      return false;
    }
  }

  /// Guarda los tokens localmente
  Future<void> _saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("access_token", access);
    await prefs.setString("refresh_token", refresh);
  }

  /// Obtiene el token guardado
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  /// Agrega el token a los headers de futuras peticiones protegidas
  Future<void> addTokenToHeader() async {
    final token = await getToken();
    if (token != null) {
      _dio.options.headers["Authorization"] = "Bearer $token";
    }
  }

  /// Cierra sesión eliminando tokens
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
    await prefs.remove("refresh_token");
  }

  /// Método para acceder a Dio desde otros servicios, ya configurado
  Dio get dio => _dio;
}
