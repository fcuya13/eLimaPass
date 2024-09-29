import 'package:flutter/material.dart';

class TarjetaPage extends StatefulWidget {
  const TarjetaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TarjetaPageState();
  }
}

class _TarjetaPageState extends State<TarjetaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 10),
            child: Column(
              children: [
                const Icon(
                  Icons.wifi,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                Hero(
                  tag: 'tarjeta',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: const Image(
                      image: AssetImage('assets/lima_pass.jpg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40, // Ajuste de posición vertical del botón
            left: 10, // Ajuste de posición horizontal del botón
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white, // Color del ícono de retroceder
              ),
              onPressed: () {
                Navigator.pop(context); // Retrocede a la pantalla anterior
              },
            ),
          ),
        ],
      ),
    );
  }
}
