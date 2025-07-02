import 'dart:convert';

import 'package:elimapass/models/entities/Viaje.dart';
import 'package:elimapass/models/responses/ViajesResponse.dart';
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

      final viajesResponse = ViajesResponse.fromJson(data);

      // Validate the response structure
      expect(viajesResponse.codigoTarjeta, equals(codigoTarjeta));
      expect(viajesResponse.viajes, isA<List<Viaje>>());

      if (viajesResponse.viajes.isNotEmpty) {
        final firstViaje = viajesResponse.viajes.first;

        // Validate Viaje properties
        expect(firstViaje.id, isA<String>());
        expect(firstViaje.fechaHora, isA<DateTime>());
        expect(firstViaje.ruta, isA<String>());
        expect(firstViaje.ruta, isNotEmpty);
        expect(firstViaje.precioFinal, isA<double>());
        expect(firstViaje.precioFinal, greaterThan(0));
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

    test('validates viajes are sorted by date (newest first)', () async {
      const codigoTarjeta = '1617756763';

      final response = await http.get(Uri.parse(
          '${BACKEND_URL}elimapass/v1/tarjetas/$codigoTarjeta/viajes'));

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body);
      final viajesResponse = ViajesResponse.fromJson(data);

      if (viajesResponse.viajes.length > 1) {
        // Verify viajes are sorted by date (assuming newest first)
        for (int i = 0; i < viajesResponse.viajes.length - 1; i++) {
          final currentViaje = viajesResponse.viajes[i];
          final nextViaje = viajesResponse.viajes[i + 1];

          // Parse dates and compare (adjust format as needed)
          final currentDate = currentViaje.fechaHora;
          final nextDate = nextViaje.fechaHora;

          expect(
              currentDate.isAfter(nextDate) ||
                  currentDate.isAtSameMomentAs(nextDate),
              isTrue,
              reason: 'Viajes should be sorted by date (newest first)');
        }
      }
    });
  });
}
