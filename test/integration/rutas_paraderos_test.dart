import 'dart:convert';

import 'package:elimapass/models/entities/Ruta.dart';
import 'package:elimapass/models/responses/ParaderoResponse.dart';
import 'package:elimapass/models/responses/RutaResponse.dart';
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

      // Use your RutaResponse class
      final rutaResponse = RutaResponse.fromJson(data);

      // Validate the response structure
      expect(rutaResponse.rutasPorServicio, isA<Map<String, List<Ruta>>>());
      expect(rutaResponse.rutasPorServicio, isNotEmpty);

      // Validate each service has routes
      rutaResponse.rutasPorServicio.forEach((servicio, rutas) {
        expect(servicio, isNotEmpty);
        expect(rutas, isA<List<Ruta>>());

        if (rutas.isNotEmpty) {
          final firstRuta = rutas.first;
          expect(firstRuta.id, isNotNull);
          expect(firstRuta.nombre, isNotNull);
          expect(firstRuta.nombre, isNotEmpty);
          expect(firstRuta.inicio, isNotNull);
          expect(firstRuta.fin, isNotNull);
          expect(firstRuta.id, isA<String>());
          expect(firstRuta.nombre, isA<String>());
          expect(firstRuta.inicio, isA<String>());
          expect(firstRuta.fin, isA<String>());
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
        final paraderoResponse = ParaderoResponse.fromJson(data);

        if (paraderoResponse.paraderos.isNotEmpty) {
          final firstParadero = paraderoResponse.paraderos.first;

          // Validate Paradero properties
          expect(firstParadero.id, isA<String>());
          expect(firstParadero.nombre, isA<String>());
          expect(firstParadero.nombre, isNotEmpty);
          expect(firstParadero.latitud, isA<String>());
          expect(firstParadero.longitud, isA<String>());
          expect(firstParadero.sentidoIda, isA<bool>());

          expect(firstParadero.nombre, isA<String>());
          expect(firstParadero.nombre.trim(), isNotEmpty);
          expect(firstParadero.sentidoIda, isA<bool>());

          // Validate coordinate ranges (assuming Lima, Peru coordinates)
          expect(double.parse(firstParadero.latitud),
              inInclusiveRange(-12.5, -11.5));
          expect(double.parse(firstParadero.longitud),
              inInclusiveRange(-77.5, -76.5));
        } else {
          print('⚠️  Route $idRuta has no paraderos');
        }
      });
    }
  });
}
