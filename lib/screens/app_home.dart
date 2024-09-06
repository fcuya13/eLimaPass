import 'package:elimapass/screens/map_test.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_page.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppHomeState();
  }
}

class _AppHomeState extends State<AppHome> {
  int _currPageIndex = 0;

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
