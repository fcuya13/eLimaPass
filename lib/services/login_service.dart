import 'dart:convert';

import 'package:elimapass/models/entities/User.dart';
import 'package:elimapass/services/user_provider.dart';
import 'package:elimapass/util/constants.dart';
import 'package:http/http.dart' as http;

class LoginService {
  UserProvider provider = UserProvider();
  static const String _baseUrl = '${BACKEND_URL}elimapass/v1/login/';

  Future<User?> login(String dni, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'dni': dni,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final user = User.fromJson(json);
      await provider.saveUser(user);
      return user;
    } else if (response.statusCode == 401) {
      throw Exception('Credenciales inválidas');
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }
}
