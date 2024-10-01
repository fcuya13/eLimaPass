import 'package:elimapass/screens/login.dart';
import 'package:flutter/material.dart';

import '../services/user_provider.dart';
import 'app_home.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({super.key});

  UserProvider provider = UserProvider();

  Future<void> checkLogin(BuildContext context) async {
    String? loggedUser = await provider.getUser();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (loggedUser == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      return;
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AppHome()));
  }

  @override
  Widget build(BuildContext context) {
    checkLogin(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      color: const Color(0XFF223E68),
      height: double.infinity,
      width: double.infinity,
      child: const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/logo.png'),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      )),
    );
  }
}
