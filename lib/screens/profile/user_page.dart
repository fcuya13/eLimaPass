import 'package:elimapass/screens/profile/tarjeta_especial_page.dart';
import 'package:elimapass/services/tarjeta_provider.dart';
import 'package:flutter/material.dart';

import '../../models/entities/Tarjeta.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  TarjetaProvider provider = TarjetaProvider();
  String tarjetaId = "";
  int tipo = 0;

  void getInfo() async {
    Tarjeta? tarjeta = await provider.getTarjeta();
    if (tarjeta != null) {
      setState(() {
        tarjetaId = tarjeta.id;
        tipo = tarjeta.tipo;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.credit_card,
                  size: 24), // Ícono para el código de tarjeta
              SizedBox(width: 8),
              Text(
                "Código de tarjeta",
                style: TextStyle(
                  fontSize: 22, // Aumentado en 2
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tarjetaId,
            style: const TextStyle(
              fontSize: 20, // Aumentado en 2
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.category, size: 24), // Ícono para el tipo de tarjeta
              SizedBox(width: 8),
              Text(
                "Tipo de tarjeta",
                style: TextStyle(
                  fontSize: 22, // Aumentado en 2
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tipo == 0
                ? "Clásica"
                : "Preferencial", // Cambia según el tipo de tarjeta
            style: const TextStyle(
              fontSize: 20, // Aumentado en 2
            ),
          ),
          if (tipo == 1) ...[
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 24), // Ícono para fecha de vencimiento
                SizedBox(width: 8),
                Text(
                  "Fecha de vencimiento",
                  style: TextStyle(
                    fontSize: 22, // Aumentado en 2
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "12/2025", // Ejemplo de fecha
              style: TextStyle(
                fontSize: 20, // Aumentado en 2
              ),
            ),
          ],
          if (tipo == 0) ...[
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const TarjetaEspecialPage(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallet),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Solicitar Tarjeta Especial',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
