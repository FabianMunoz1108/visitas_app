import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_app/config/url_api.dart';
import 'package:visitas_app/models/usuario_model.dart';

/// Servicios para usuarios
class LoginService {
  final String _baseUrl = UrlApi.baseUrl;

  /// Método que valida las credenciales del usuario
  /// Retorna true si las credenciales son correctas
  /// Retorna false si las credenciales son incorrectas
  Future<bool> login(UsuarioModel model) async {
    final response = await http.post(Uri.parse('$_baseUrl/usuario'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
