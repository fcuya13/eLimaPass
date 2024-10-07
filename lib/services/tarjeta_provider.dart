import 'package:shared_preferences/shared_preferences.dart';

import '../models/responses/LoginResponse.dart';

class TarjetaProvider {
  Future<void> saveTarjeta(LoginResponse userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tarjeta_id', userData.tarjeta);
  }

  Future<String?> getTarjeta() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('tarjeta_id');

    print(userId);
    if (userId != null) {
      return userId;
    }

    return null;
  }

  Future<void> removeTarjeta() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tarjeta_id');
  }
}
