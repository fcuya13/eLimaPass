import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/constants.dart';

class RegisterService {
  static const String _baseUrl = '${BACKEND_URL}elimapass/v1/signup/';
  static const String _dniApiUrl = 'https://apiperu.dev/api/dni';
  static const String _dniApiToken = 'YOUR_API_TOKEN_HERE'; // Reemplaza con tu token de API

  Future<void> register(String dni, String email, String nombres,
      String apellidos, String password, String numTarjeta) async {
      
    // Paso 1: Validar DNI y nombres usando la API de consulta de DNI
    final dniValidationResponse = await http.post(
      Uri.parse(_dniApiUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_dniApiToken',
      },
      body: jsonEncode({'dni': dni}),
    );

    if (dniValidationResponse.statusCode != 200) {
      throw Exception('Error al validar el DNI');
    }

    final dniData = jsonDecode(dniValidationResponse.body);
    if (dniData['success'] != true) {
      throw Exception('No se encontró el DNI');
    }

    // Verificar que el nombre y apellido coincidan
    final apiNombres = dniData['data']['nombres'];
    final apiApellidoPaterno = dniData['data']['apellido_paterno'];
    final apiApellidoMaterno = dniData['data']['apellido_materno'];

    if (!(nombres.contains(apiNombres) &&
          apellidos.contains(apiApellidoPaterno) &&
          apellidos.contains(apiApellidoMaterno))) {
      throw Exception('El DNI no coincide con el nombre proporcionado');
    }

    // Paso 2: Si la validación es exitosa, proceder con el registro
    var body = {
      'dni': dni,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'password': password
    };

    if (numTarjeta.isNotEmpty) {
      body['num_tarjeta'] = numTarjeta;
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return;
    }

    if (response.statusCode == 400) {
      throw Exception('DNI o tarjeta ya existen');
    }

    throw Exception('Ha ocurrido un error desconocido');
  }
}

