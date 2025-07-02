import 'dart:convert';

import 'package:elimapass/models/entities/Recarga.dart';
import 'package:elimapass/models/responses/RecargaResponse.dart';
import 'package:elimapass/util/constants.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('Recargas API Integration Tests', () {
    test('returns recargas history for valid tarjeta', () async {
      const codigoTarjeta = '1617756763';

      final response = await http.get(
        Uri.parse(
            '${BACKEND_URL}elimapass/v1/tarjetas/$codigoTarjeta/recargas'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, equals(200));

      final data = jsonDecode(response.body);

      // Use HistorialRecargasResponse class
      final recargasResponse = RecargasResponse.fromJson(data);

      expect(recargasResponse.codigoTarjeta, equals(codigoTarjeta));
      expect(recargasResponse.recargas, isA<List<Recarga>>());

      if (recargasResponse.recargas.isNotEmpty) {
        final firstRecarga = recargasResponse.recargas.first;

        // Validate Recarga properties
        expect(firstRecarga.id, isA<String>());
        expect(firstRecarga.id, isNotEmpty);
        expect(firstRecarga.fechaHora, isA<DateTime>());
        expect(firstRecarga.monto, isA<double>());
        expect(firstRecarga.monto, greaterThan(0));
        expect(firstRecarga.medioPago, isA<String>());
        expect(firstRecarga.medioPago, isNotEmpty);

        // Validate reasonable recharge amounts
        expect(firstRecarga.monto, inInclusiveRange(1.0, 500.0));

        // Validate payment methods (adjust based on your valid payment methods)
        expect(
            firstRecarga.medioPago,
            anyOf(
              equals('yape'),
              equals('tarjeta'),
            ));
      }
    });

    test('returns 404 for non-existent tarjeta', () async {
      const invalidCodigoTarjeta = '9999999991';

      final response = await http.get(
        Uri.parse(
            '${BACKEND_URL}elimapass/v1/tarjetas/$invalidCodigoTarjeta/recargas'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, equals(404));

      final data = jsonDecode(response.body);
      expect(data, contains('error'));
      expect(data['error'], equals('La tarjeta no existe'));
    });

    test('validates recargas are sorted by date (newest first)', () async {
      const codigoTarjeta = '1617756763';

      final response = await http.get(
        Uri.parse(
            '${BACKEND_URL}elimapass/v1/tarjetas/$codigoTarjeta/recargas'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body);
      final recargasResponse = RecargasResponse.fromJson(data);

      if (recargasResponse.recargas.length > 1) {
        // Verify recargas are sorted by date (assuming newest first)
        for (int i = 0; i < recargasResponse.recargas.length - 1; i++) {
          final currentRecarga = recargasResponse.recargas[i];
          final nextRecarga = recargasResponse.recargas[i + 1];

          // Parse dates and compare
          final currentDate = currentRecarga.fechaHora;
          final nextDate = nextRecarga.fechaHora;

          expect(
              currentDate.isAfter(nextDate) ||
                  currentDate.isAtSameMomentAs(nextDate),
              isTrue,
              reason: 'Recargas should be sorted by date (newest first)');
        }

        print('✅ Recargas are properly sorted by date');
      }
    });

    test('validates payment method categories', () async {
      const codigoTarjeta = '1617756763';

      final response = await http.get(
        Uri.parse(
            '${BACKEND_URL}elimapass/v1/tarjetas/$codigoTarjeta/recargas'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body);
      final recargasResponse = RecargasResponse.fromJson(data);

      if (recargasResponse.recargas.isNotEmpty) {
        // Group by payment method to validate variety
        final paymentMethods = <String, int>{};
        for (var recarga in recargasResponse.recargas) {
          paymentMethods[recarga.medioPago] =
              (paymentMethods[recarga.medioPago] ?? 0) + 1;
        }

        paymentMethods.forEach((method, count) {
          expect(method, isNotEmpty);
          expect(count, greaterThan(0));
        });

        // Validate at least some variety in payment methods (if data allows)
        expect(paymentMethods.keys, isNotEmpty);
      }
    });

    test('validates recharge amounts are reasonable', () async {
      const codigoTarjeta = '1617756763';

      final response = await http.get(
        Uri.parse(
            '${BACKEND_URL}elimapass/v1/tarjetas/$codigoTarjeta/recargas'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, equals(200));
      final data = jsonDecode(response.body);
      final recargasResponse = RecargasResponse.fromJson(data);

      if (recargasResponse.recargas.isNotEmpty) {
        for (var recarga in recargasResponse.recargas) {
          // Validate each recharge amount
          expect(recarga.monto, greaterThan(0));
          expect(recarga.monto,
              lessThanOrEqualTo(500.0)); // Max reasonable recharge
          expect(recarga.monto, inInclusiveRange(1.0, 500.0));

          // Validate currency precision (max 2 decimal places)
          final montoStr = recarga.monto.toStringAsFixed(2);
          expect(double.parse(montoStr), equals(recarga.monto));
        }
      }
    });
  });
}
