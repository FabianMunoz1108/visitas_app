import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitas_app/models/credenciales.dart';

class VisitasService{

final String _baseUrl = 'https://hammerhead-app-b4cm2.ondigitalocean.app/final-dart2';

  Future<bool> login(Credenciales credenciales) async {

    final response = await http.post(
      Uri.parse('$_baseUrl/usuario'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:jsonEncode(credenciales.toJson())
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}