import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elimapass/models/entities/User.dart';

class LoginService {
  static const String _baseUrl = 'https://192.168.1.88:8000/elimapass/v1/login/';

  Future<User?> login(String dni, String password) async{
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
      await _saveUser(user);
      return user;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Error logging in: ${response.statusCode}');
    }
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_dni', user.dni);
    await prefs.setString('user_nombres', user.nombres);
    await prefs.setString('user_apellidos', user.apellidos);
    await prefs.setString('user_email', user.email);
  }
}