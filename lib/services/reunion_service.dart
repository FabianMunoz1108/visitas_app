import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_app/config/url_api.dart';
import 'package:visitas_app/models/reunion_model.dart';

/// Servicios para reuniones
class ReunionService {
  final String _baseUrl = UrlApi.baseUrl;

  /// Método que obtiene las reuniones
  /// Retorna una lista de reuniones
  /// Retorna una excepción si no se pudo cargar la lista
  Future<List<ReunionModel>> getReuniones() async {
    final response = await http.get(Uri.parse('$_baseUrl/reunion'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((reunion) => ReunionModel.fromJson(reunion)).toList();
    } else {
      throw Exception('Failed to load reuniones');
    }
  }

  /// Guarda una reunión
  /// Retorna el id de la reunión guardada
  /// Retorna una excepción si no se pudo guardar la reunión
  Future<int> postReunion(ReunionModel model) async {
    final data = model.toJson()
      ..remove('reuId'); // Elimina el id para que no se envíe en el body

    final response = await http.post(Uri.parse('$_baseUrl/reunion'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to add reunion');
    } else {
      final nuevo = ReunionModel.fromJson(json.decode(response.body));
      return nuevo.reuId;
    }
  }

  /// Actualiza una reunión
  /// Retorna el id de la reunión actualizada
  /// Retorna una excepción si no se pudo actualizar la reunión
  Future<int> putReunion(ReunionModel model) async {
    final data = model.toJson()
      ..remove('reuId'); // Elimina el id para que no se envíe en el body

    final response =
        await http.put(Uri.parse('$_baseUrl/reunion/${model.reuId}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to update reunion');
    } else {
      return model.reuId;
    }
  }

  /// Elimina una reunión
  /// Retorna true si se eliminó correctamente
  /// Retorna una excepción si no se pudo eliminar la reunión
  Future<bool> deleteReunion(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/reunion/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete reunion');
    }
  }
}
