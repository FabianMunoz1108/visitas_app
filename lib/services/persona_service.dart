import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_app/config/url_api.dart';
import 'package:visitas_app/models/persona_model.dart';

/// Servicios para personas
class PersonaService {
  final String _baseUrl = UrlApi.baseUrl;

  /// Método que obtiene el catálogo de personas
  /// Retorna una lista de personas
  /// Retorna una excepción si no se pudo cargar la lista
  Future<List<PersonaModel>> getPersonas() async {
    final response = await http.get(Uri.parse('$_baseUrl/persona'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((persona) => PersonaModel.fromJson(persona)).toList();
    } else {
      throw Exception('Failed to load personas');
    }
  }

  /// Guarda una persona
  /// Retorna el id de la persona guardada
  /// Retorna una excepción si no se pudo guardar la persona
  Future<int> postPersona(PersonaModel model) async {
    final data = model.toJson()
      ..remove('perId'); // Elimina el id para que no se envíe en el body

    final response = await http.post(Uri.parse('$_baseUrl/persona'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to add persona');
    } else {
      final nuevo = PersonaModel.fromJson(json.decode(response.body));
      return nuevo.perId;
    }
  }

  /// Actualiza una persona
  /// Retorna el id de la persona actualizada
  /// Retorna una excepción si no se pudo actualizar la persona
  Future<int> putPersona(PersonaModel model) async {
    final data = model.toJson()
      ..remove('perId'); // Elimina el id para que no se envíe en el body

    final response =
        await http.put(Uri.parse('$_baseUrl/persona/${model.perId}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to update persona');
    } else {
      return model.perId;
    }
  }

  /// Elimina una persona
  /// Retorna true si se eliminó correctamente
  /// Retorna una excepción si no se pudo eliminar la persona
  Future<bool> deletePersona(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/persona/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete persona');
    }
  }
}
