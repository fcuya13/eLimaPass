import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/entities/Viaje.dart';

class ViajeItem extends StatelessWidget {
  final Viaje viaje;

  ViajeItem({required this.viaje});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Línea: ${viaje.ruta}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  '${DateFormat("dd MMM yyyy - h.mma", 'es_ES').format(viaje.fechaHora)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '-S/.${viaje.precioFinal.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.red,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}