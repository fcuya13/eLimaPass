import 'package:shared_preferences/shared_preferences.dart';

import '../models/entities/User.dart';

class UserProvider {
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
  }

  Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    print(userId);
    if (userId != null) {
      return userId;
    }

    return null;
  }

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }
}
