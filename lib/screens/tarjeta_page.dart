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
        appBar: null,
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 150, horizontal: 10),
            child: Column(
              children: [
                Icon(
                  Icons.wifi,
                  size: 50,
                ),
                SizedBox(
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
            )));
  }
}
