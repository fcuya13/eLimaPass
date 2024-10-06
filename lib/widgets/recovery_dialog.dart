import 'package:flutter/material.dart';

class RecoveryDialog extends StatelessWidget {
  const RecoveryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 30),
          SizedBox(width: 10),
          Text(
            "Contraseña Recuperada",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        "Tu contraseña ha sido cambiada exitosamente. Por favor, inicia sesión con tu nueva contraseña.",
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
            Navigator.of(context).pop();
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
