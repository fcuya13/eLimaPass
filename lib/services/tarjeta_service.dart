import 'dart:convert';

import 'package:elimapass/models/entities/Recarga.dart';
import 'package:elimapass/models/entities/Tarjeta.dart';
import 'package:elimapass/models/entities/Viaje.dart';
import 'package:elimapass/models/responses/RecargaResponse.dart';
import 'package:elimapass/models/responses/ViajesResponse.dart';
import 'package:elimapass/services/tarjeta_provider.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../util/constants.dart';

class TarjetaService {
  static const String _baseUrl = '${BACKEND_URL}elimapass/v1/tarjetas';
  TarjetaProvider provider = TarjetaProvider();

  Future<double> getSaldo() async {
    Tarjeta? tarjeta = await provider.getTarjeta();

    if (tarjeta == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl/${tarjeta.id}/saldo";

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
    Tarjeta? tarjeta = await provider.getTarjeta();

    if (tarjeta == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl/${tarjeta.id}/viajes";

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final viajesResponse = ViajesResponse.fromJson(json);
      return viajesResponse.viajes;
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }

  Future<void> setLimite(double limite) async {
    Tarjeta? tarjeta = await provider.getTarjeta();

    if (tarjeta == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl${tarjeta.id}/cambiar-limite";

    var body = {"limite": limite};

    final response =
        await http.put(Uri.parse(url), body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }

  Future<List<Recarga>> getRecargas() async {
    Tarjeta? tarjeta = await provider.getTarjeta();

    if (tarjeta == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl/${tarjeta.id}/recargas";

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final recargasResponse = RecargasResponse.fromJson(json);
      return recargasResponse.recargas;
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }

  Future<bool> setRecarga(double monto, String medio_pago) async {
    Tarjeta? tarjeta = await provider.getTarjeta();

    if (tarjeta == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "${BACKEND_URL}elimapass/v1/recargar";

    var body = {
      "codigo_tarjeta": tarjeta.id,
      "monto_recargado": monto,
      "medio_pago": medio_pago
    };

    final response =
        await http.post(Uri.parse(url), body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 201) {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
    print(response.body);
    return true;
  }

  Future<void> uploadSolicitud({
    required List<ImageFile> dni,
    required List<ImageFile> carne,
    required String codigoTarjeta,
  }) async {
    final url = Uri.parse(
        '$BACKEND_URL/elimapass/v1/solicitudes'); // Cambia esto por tu URL.

    final request = http.MultipartRequest('POST', url);

    request.files
        .add(await http.MultipartFile.fromPath('dni_frontal', dni[0].path!));
    request.files
        .add(await http.MultipartFile.fromPath('dni_reversa', dni[1].path!));
    request.files.add(
        await http.MultipartFile.fromPath('carnet_frontal', carne[0].path!));
    request.files.add(
        await http.MultipartFile.fromPath('carnet_reversa', carne[1].path!));

    request.fields['codigo_tarjeta'] = codigoTarjeta;

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        return;
      } else if (response.statusCode == 400) {
        throw Exception(
            "Ya tienes una solicitud pendiente. Por favor espera a la respuesta por correo.");
      } else {
        throw Exception(
            "Ha ocurrido un error inesperado, por favor inténtalo más tarde");
      }
    } catch (e) {
      rethrow;
    }
  }
}
