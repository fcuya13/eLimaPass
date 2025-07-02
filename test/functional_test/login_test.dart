import 'dart:convert';

import 'package:elimapass/util/constants.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  // Adjust the backend URL as needed
  const backendUrl = '${BACKEND_URL}elimapass/v1/login';

  group('Login API', () {
    test('returns 200 and valid response for correct credentials', () async {
      // Replace these with valid test credentials present in your test DB
      final loginRequest = {
        'dni': '75995741',
        'password': 'adminadmin',
      };

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginRequest),
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body);
      expect(data, contains('id'));
      expect(data, contains('tarjeta'));
      expect(data, contains('tipo'));
    });

    test('returns 401 for wrong credentials', () async {
      final loginRequest = {
        'dni': '88888888',
        'password': 'wrongpassword',
      };

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginRequest),
      );

      expect(response.statusCode, equals(401));
      final data = jsonDecode(response.body);
      expect(data, contains('error'));
      expect(data['error'], equals('Credenciales incorrectas'));
    });
  });
}
