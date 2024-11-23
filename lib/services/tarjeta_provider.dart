import 'package:elimapass/models/entities/Tarjeta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/responses/LoginResponse.dart';

class TarjetaProvider {
  Future<void> saveTarjeta(LoginResponse userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tarjeta_id', userData.tarjeta);
    await prefs.setInt('tarjeta_tipo', userData.tipo);
  }

  Future<Tarjeta?> getTarjeta() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('tarjeta_id');
    final tipo = prefs.getInt('tarjeta_tipo');

    if (userId != null && tipo != null) {
      return Tarjeta(id: userId, tipo: tipo);
    }

    return null;
  }

  Future<void> removeTarjeta() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tarjeta_id');
  }

  static const String _saldoMinimoKey = 'saldoMinimo';

  // Guardar el saldo mínimo
  Future<void> setSaldoMinimo(double saldo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_saldoMinimoKey, saldo);
  }

  // Obtener el saldo mínimo guardado
  Future<double?> getSaldoMinimo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_saldoMinimoKey);
  }

  // Eliminar el saldo mínimo guardado (opcional)
  Future<void> removeSaldoMinimo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_saldoMinimoKey);
  }
}
