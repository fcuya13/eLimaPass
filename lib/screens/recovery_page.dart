import 'package:elimapass/screens/login.dart';
import 'package:elimapass/screens/register_page.dart';
import 'package:elimapass/util/validators.dart';
import 'package:elimapass/widgets/recovery_dialog.dart';
import 'package:flutter/material.dart';

import '../widgets/car_background.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RecoveryScreenState();
  }
}

class _RecoveryScreenState extends State<RecoveryScreen> with Validators{
  var _dni = "";
  var _email = "";

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      showDialog(context: context, builder: (BuildContext context) {
        return RecoveryDialog();
      });
      /*
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const LoginScreen(),
          )
      );
       */
    }
    print({
      _dni,
      _email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const CarBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image(
                        image: const AssetImage(
                          'assets/logo.png',
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      _textFields(),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff111318),
                          foregroundColor: const Color(0XFFFFFFFF),
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _submit,
                        child: const Text(
                          "Recuperar Contraseña",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿No tienes una cuenta?",
                              style:
                              TextStyle(color: Colors.white, fontSize: 13)),
                          const SizedBox(
                            width: 6,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text("¡Regístrate aquí!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: Colors.white,
                                  )))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFields() {
    return Column(children: [
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Color(0xffffb4ab)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: 'DNI',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: const Color(0xff111318).withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff111318),
        ),
        validator: (value) => validateDni(value),
        onSaved: (value){
          _dni = value!;
        },
      ),
      const SizedBox(
        height: 20,
      ),
      TextFormField(
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Color(0xffffb4ab)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: 'Correo electrónico',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: const Color(0xff111318).withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff111318),
        ),
        validator: (value)  => validateEmail(value),
        onSaved: (value){
          _email = value!;
        },
      )
    ]);
  }

}