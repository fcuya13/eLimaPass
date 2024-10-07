import 'package:elimapass/screens/map_test.dart';
import 'package:elimapass/services/tarjeta_provider.dart';
import 'package:flutter/material.dart';

import 'alert_page.dart';
import 'home_page.dart';
import 'login.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppHomeState();
  }
}

class _AppHomeState extends State<AppHome> {
  int _currPageIndex = 0;
  TarjetaProvider provider = TarjetaProvider();

  final destinations = <Widget>[
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Inicio',
    ),
    const NavigationDestination(
      icon: Icon(Icons.map_outlined),
      selectedIcon: Icon(Icons.map),
      label: 'Rutas',
    ),
  ];

  final appbarTitles = ["Mi eLimaPass", "Rutas y Paraderos"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0XFF405f90),
        title: Text(
          appbarTitles[_currPageIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return const SizedBox(
                      height: 300,
                      child: AlertPage(),
                    );
                  },
                );
              },
              icon: const Icon(Icons.add_alert),
              color: Colors.white),
          IconButton(
              onPressed: () async {
                await provider.removeTarjeta();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) =>
                      false, // Elimina todas las rutas anteriores
                );
              },
              icon: const Icon(Icons.logout),
              color: Colors.white),
        ],
      ),
      body: <Widget>[const HomePage(), const MapTest()][_currPageIndex],
      bottomNavigationBar: NavigationBar(
        height: 65,
        onDestinationSelected: (int index) {
          setState(() {
            _currPageIndex = index;
          });
        },
        selectedIndex: _currPageIndex,
        destinations: destinations,
      ),
    );
  }
}
