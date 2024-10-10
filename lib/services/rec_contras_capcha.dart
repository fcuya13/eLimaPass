import 'dart:convert';
import 'package:elimapass/util/constants.dart';
import 'package:http/http.dart' as http;

class PasswordRecoveryService {
  static const String _baseUrl = '${BACKEND_URL}elimapass/v1/recover_password/';

  // Generar CAPTCHA
  Future<String> generarCaptcha() async {
    final response = await http.get(
      Uri.parse('${_baseUrl}captcha'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['captcha']; // Devuelve el código CAPTCHA
    } else {
      throw Exception('No se pudo generar el CAPTCHA');
    }
  }

  // Validar CAPTCHA y restablecer la contraseña
  Future<void> resetPassword(String email, String newPassword, String captcha, String userCaptchaInput) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}validate_captcha'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'new_password': newPassword,
        'captcha': captcha,
        'user_captcha_input': userCaptchaInput,
      }),
    );

    if (response.statusCode == 200) {
      print('Contraseña restablecida exitosamente');
    } else if (response.statusCode == 401) {
      throw Exception('CAPTCHA inválido');
    } else if (response.statusCode == 404) {
      throw Exception('Correo electrónico no encontrado');
    } else {
      throw Exception('Ha ocurrido un error. Inténtelo más tarde');
    }
  }
}
