import 'package:elimapass/screens/login.dart';
import 'package:elimapass/services/RegisterService.dart';
import 'package:elimapass/util/validators.dart';
import 'package:flutter/material.dart';

import '../widgets/car_background.dart';
import '../widgets/loading_foreground.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> with Validators {
  var _dni = "";
  var _nombres = "";
  var _apellidos = "";
  var _email = "";
  var _password = "";
  var _tarjeta = "";

  final _registerService = RegisterService();
  bool loading = false;
  bool success = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  void _submit() async {
    setState(() {
      loading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        // Intento de registro en el servicio con los datos ingresados
        await _registerService.register(
            _dni, _email, _nombres, _apellidos, _password, _tarjeta);
        
        // Si la autenticación es exitosa, navega a la pantalla de login
        setState(() {
          success = true;
        });
      } catch (e) {
        // Si la autenticación falla, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de registro: $e')),
        );
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const CarBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
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
                          "Registrarme",
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
                          const Text("¿Ya estás registrado?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
                          const SizedBox(
                            width: 6,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text("¡Inicia sesión aquí!",
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
          if (loading) const LoadingForeground(),
          if (success)
            AlertDialog(
              title: const Text("Registro exitoso"),
              content: const Text(
                "Presione el botón para iniciar sesión",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (ctx) => const LoginScreen(),
                        ),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text("Ir a inicio"),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Campos de entrada del formulario
  Widget _textFields() {
    return Column(children: [
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'DNI',
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) => validateDni(value),
        onSaved: (value) {
          _dni = value!;
        },
      ),
      // Campos adicionales para correo, nombres, apellidos, contraseña, y tarjeta
    ]);
  }
}
