import 'dart:convert';

import 'package:elimapass/util/constants.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('GET /rutas', () {
    test('returns grouped rutas', () async {
      final response =
          await http.get(Uri.parse('${BACKEND_URL}elimapass/v1/rutas'));

      expect(response.statusCode, equals(200));

      final data = jsonDecode(response.body);
      expect(data, isA<Map>());
      // Optionally, check that each value is a List of rutas
      data.forEach((servicio, rutas) {
        expect(rutas, isA<List>());
        if (rutas.isNotEmpty) {
          final ruta = rutas[0];
          expect(ruta, contains('id'));
          expect(ruta, contains('nombre'));
          expect(ruta, contains('inicio'));
          expect(ruta, contains('finalDestino'));
        }
      });
    });
  });

  group('GET /paraderos/{idRuta}', () {
    for (var idRuta in ['1', '2', '3']) {
      test('returns paraderos for ruta $idRuta', () async {
        final response = await http
            .get(Uri.parse('${BACKEND_URL}elimapass/v1/paraderos/$idRuta'));

        expect(response.statusCode, equals(200));
        final data = jsonDecode(response.body);
        expect(data, isA<List>());
        if (data.isNotEmpty) {
          final paradero = data[0];
          expect(paradero, contains('id'));
          expect(paradero, contains('nombre'));
          expect(paradero, contains('latitud'));
          expect(paradero, contains('longitud'));
          expect(paradero, contains('sentidoIda'));
        }
      });
    }
  });
}
