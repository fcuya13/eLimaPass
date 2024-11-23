import 'package:flutter/material.dart';

import '../screens/app_home.dart';

class DocumentsDialog extends StatelessWidget {
  const DocumentsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 30),
          SizedBox(width: 10),
          Text(
            "¡Subida exitosa!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        "Tus archivos se subieron exitosamente. Los revisaremos y te informaremos de los cambios por correo",
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (ctx) => const AppHome(),
                ),
                (Route<dynamic> route) => false);
          },
          child: const Text(
            "Aceptar",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
