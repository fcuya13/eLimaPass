import 'dart:convert';

import 'package:elimapass/models/entities/Viaje.dart';
import 'package:elimapass/models/responses/ViajesResponse.dart';
import 'package:elimapass/services/tarjeta_provider.dart';
import 'package:http/http.dart' as http;

import '../util/constants.dart';

class TarjetaService {
  static const String _baseUrl = '${BACKEND_URL}elimapass/v1/tarjetas/';
  TarjetaProvider provider = TarjetaProvider();

  Future<double> getSaldo() async {
    String? tarjetaId = await provider.getTarjeta();

    if (tarjetaId == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl$tarjetaId/saldo/";

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final saldo = json["saldo"];
      return saldo;
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }

  Future<List<Viaje>> getViajes() async {
    String? tarjetaId = await provider.getTarjeta();

    if (tarjetaId == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl$tarjetaId/viajes/";

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final viajesResponse = ViajesResponse.fromJson(json);
      print(viajesResponse);
      return viajesResponse.viajes;
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }
}
