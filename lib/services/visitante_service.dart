import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_app/config/url_api.dart';
import 'package:visitas_app/models/visitante_model.dart';

/// Servicios para visitantes
class VisitanteService {
  final String _baseUrl = UrlApi.baseUrl;

  /// Método que obtiene el catálogo de visitantes
  /// Retorna una lista de visitantes
  /// Retorna una excepción si no se pudo cargar la lista
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

  /// Guarda un visitante
  /// Retorna el id del visitante guardado
  /// Retorna una excepción si no se pudo guardar el visitante
  Future<int> postVisitante(VisitanteModel model) async {
    final data = model.toJson()
      ..remove('visId'); // Elimina el id para que no se envíe en el body

    final response = await http.post(Uri.parse('$_baseUrl/visitante'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to add visitante');
    } else {
      final nuevo = VisitanteModel.fromJson(json.decode(response.body));
      return nuevo.visId;
    }
  }

  /// Actualiza un visitante
  /// Retorna el id del visitante actualizado
  /// Retorna una excepción si no se pudo actualizar el visitante
  Future<int> putVisitante(VisitanteModel model) async {
    final data = model.toJson()
      ..remove('visId'); // Elimina el id para que no se envíe en el body

    final response =
        await http.put(Uri.parse('$_baseUrl/visitante/${model.visId}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data));

    if (response.statusCode != 200) {
      throw Exception('Failed to update visitante');
    } else {
      return model.visId;
    }
  }

  /// Elimina un visitante
  /// Retorna true si se eliminó correctamente
  /// Retorna una excepción si no se pudo eliminar el visitante
  Future<bool> deleteVisitante(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/visitante/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete visitante');
    }
  }
}
