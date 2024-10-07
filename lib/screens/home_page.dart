import 'package:elimapass/screens/tarjeta_page.dart';
import 'package:elimapass/services/tarjeta_service.dart';
import 'package:flutter/material.dart';

import '../models/entities/Viaje.dart';
import '../widgets/ViajesList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var _isVisible = false;
  var _loading = false;
  List<Viaje> _viajes = [];
  TarjetaService tarjetaService = TarjetaService();
  double _saldo = 0;

  Future<void> cargarViajes() async {
    List<Viaje> listaViajes = await tarjetaService.getViajes();

    setState(() {
      _viajes = listaViajes;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarViajes();
  }

  void _changeVisibility() async {
    if (_isVisible) {
      setState(() {
        _isVisible = !_isVisible;
      });
      return;
    }

    try {
      setState(() {
        _loading = true;
      });
      double saldoActual = await tarjetaService.getSaldo();
      setState(() {
        _saldo = saldoActual;
        _isVisible = !_isVisible;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ha ocurrido un error')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'tarjeta',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: GestureDetector(
                    child: const Image(
                      image: AssetImage('assets/lima_pass.jpg'),
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const TarjetaPage(),
                          ))
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Saldo(_saldo),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Viajes Recientes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: ViajesList(viajes: _viajes)),
            ],
          ),
        ),
        Positioned(
          bottom: 35,
          right: 20,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {},
            child: const Row(
              children: [
                Icon(Icons.wallet),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Recargar',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget Saldo(double saldo) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.onSurface,
                spreadRadius: 1,
                blurRadius: 0.5)
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text(
                "Saldo Actual:",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(
                width: 12,
              ),
              Visibility(
                visible: _isVisible,
                child: Text(
                  "S/. $saldo",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Visibility(
                visible: _loading,
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              _changeVisibility();
            },
            child: _isVisible
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
        ],
      ),
    );
  }
}
