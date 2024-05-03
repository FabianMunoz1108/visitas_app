import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_app/config/url_api.dart';
import 'package:visitas_app/models/persona_model.dart';
import 'package:visitas_app/models/reunion_model.dart';
import 'package:visitas_app/models/usuario_model.dart';
import 'package:visitas_app/models/visitante_model.dart';

class VisitasService {
  final String _baseUrl = UrlApi.baseUrl;

  /// Método que valida las credenciales del usuario
  Future<bool> login(UsuarioModel credenciales) async {
    final response = await http.post(Uri.parse('$_baseUrl/usuario'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(credenciales.toJson()));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// Método que obtiene el catálogo de visitantes
  Future<List<VisitanteModel>> getVisitantes() async {
    final response = await http.get(Uri.parse('$_baseUrl/visitante'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((visitante) => VisitanteModel.fromJson(visitante))
          .toList();
    } else {
      throw Exception('Failed to load visitantes');
    }
  }

  /// Método que obtiene el catálogo de personas
  Future<List<PersonaModel>> getPersonas() async {
    final response = await http.get(Uri.parse('$_baseUrl/persona'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((persona) => PersonaModel.fromJson(persona)).toList();
    } else {
      throw Exception('Failed to load personas');
    }
  }

  /// Método que obtiene las reuniones
  Future<List<ReunionModel>> getReuniones() async {
    final response = await http.get(Uri.parse('$_baseUrl/reunion'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((reunion) => ReunionModel.fromJson(reunion)).toList();
    } else {
      throw Exception('Failed to load reuniones');
    }
  }
}
