import 'dart:convert';

import 'package:elimapass/util/constants.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('Saldo API Integration Tests', () {
    test('returns saldo for valid tarjeta', () async {
      const codigoTarjeta = '1617756763';

      final response = await http.get(
        Uri.parse('${BACKEND_URL}elimapass/v1/tarjetas/$codigoTarjeta/saldo'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, equals(200));

      final data = jsonDecode(response.body);

      // Validate response structure
      double saldo = data["saldo"];
      expect(saldo, inInclusiveRange(0.0, 999.99)); //
      expect(saldo, isA<double>());
      expect(saldo.isFinite, isTrue);
      expect(saldo.isNaN, isFalse);
    });

    test('returns 404 for non-existent tarjeta', () async {
      const invalidCodigoTarjeta = '9999999999';

      final response = await http.get(
        Uri.parse(
            '${BACKEND_URL}elimapass/v1/tarjetas/$invalidCodigoTarjeta/saldo'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, equals(404));

      final data = jsonDecode(response.body);
      expect(data, contains('error'));
      expect(data['error'], equals('Tarjeta no existe'));
    });
  });
}
