import 'dart:convert';

import 'package:elimapass/util/constants.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('GET /tarjetas/{codigoTarjeta}/viajes', () {
    test('returns viajes for a valid tarjeta', () async {
      // Use a valid codigoTarjeta existing in your test DB
      const codigoTarjeta = '1617756763';

      final response = await http.get(Uri.parse(
          '${BACKEND_URL}elimapass/v1/tarjetas/$codigoTarjeta/viajes'));

      expect(response.statusCode, equals(200));

      final data = jsonDecode(response.body);

      expect(data, contains('codigoTarjeta'));
      expect(data, contains('viajes'));
      expect(data['codigoTarjeta'], equals(codigoTarjeta));
      expect(data['viajes'], isA<List>());
      // Optionally, check fields of the first viaje if present
      if (data['viajes'].isNotEmpty) {
        final viaje = data['viajes'][0];
        expect(viaje, contains('id'));
        expect(viaje, contains('fechaHora'));
        expect(viaje, contains('ruta'));
        expect(viaje, contains('precioFinal'));
      }
    });

    test('returns 404 for non-existent tarjeta', () async {
      const invalidCodigoTarjeta = '1617756762';

      final response = await http.get(Uri.parse(
          '${BACKEND_URL}elimapass/v1/tarjetas/$invalidCodigoTarjeta/viajes'));

      expect(response.statusCode, equals(404));

      final data = jsonDecode(response.body);
      expect(data, contains('error'));
      expect(data['error'], equals('Tarjeta no existe'));
    });
  });
}
