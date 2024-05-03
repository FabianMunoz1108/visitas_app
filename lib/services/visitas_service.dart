import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_app/config/url_api.dart';
import 'package:visitas_app/models/persona_model.dart';
import 'package:visitas_app/models/reunion_model.dart';
import 'package:visitas_app/models/usuario_model.dart';
import 'package:visitas_app/models/visitante_model.dart';

class VisitasService {
  final String _baseUrl = UrlApi.baseUrl;

  /******************/
  /*    Usuarios    */
  /******************/
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

  /********************/
  /*    Visitantes    */
  /********************/
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

  /******************/
  /*    Personas    */
  /******************/
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

  /*******************/
  /*    Reuniones    */
  /*******************/
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
