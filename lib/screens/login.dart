import 'package:elimapass/screens/recovery_page.dart';
import 'package:elimapass/screens/register_page.dart';
import 'package:elimapass/util/validators.dart';
import 'package:flutter/material.dart';
import '../widgets/car_background.dart';
import 'app_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> with Validators {
  var _dni = "";
  var _password = "";
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const AppHome(),
        ), (Route<dynamic> route) => false
      );
    }
    print({
      _dni,
      _password,
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
                          "Iniciar sesión",
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
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => const RecoveryScreen(),
                                  ),
                                );
                              },
                              child: const Text("¿Olvidaste tu contraseña?",
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
        obscureText: true,
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Color(0xffffb4ab)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: 'Contraseña',
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
        validator: (value) => validatePassword(value),
        onSaved: (value){
          _password = value!;
        },
      )
    ]);
  }
}
