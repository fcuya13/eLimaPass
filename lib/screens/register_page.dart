import 'package:elimapass/screens/login.dart';
import 'package:flutter/material.dart';
import '../widgets/car_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _dni = "";
  var _nombres = "";
  var _apellidos = "";
  var _email = "";
  var _password = "";
  var _tarjeta = "";

  final _formKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      print({
        _dni,
        _nombres,
        _apellidos,
        _email,
        _password,
        _tarjeta
      });
    }
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
        validator: (value) {
          if (value == null ||
              value.trim().length != 8 ||
              !value.contains(RegExp(r'[0-9]'))) {
            return 'Ingrese un DNI válido';
          }
          return null;
        },
        onSaved: (value) {
          _dni = value!;
        },
      ),
      const SizedBox(
        height: 10,
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
        validator: (value) {
          if (value == null || !value.contains("@")) {
            return 'Ingrese un correo válido';
          }
          return null;
        },
        onSaved: (value) {
          _email = value!;
        },
      ),
      const SizedBox(
        height: 10,
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
          hintText: 'Nombres',
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
        onSaved: (value) {
          _nombres = value!;
        },
      ),
      const SizedBox(
        height: 10,
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
          hintText: 'Apellidos',
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
        onSaved: (value) {
          _apellidos = value!;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: passController,
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
        validator: (value) {
          if (value == null || value.length < 8) {
            return 'Ingrese una contraseña de 8 caracteres';
          }
          return null;
        },
        onSaved: (value) {
          _password = value!;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: confirmPassController,
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
          hintText: 'Confirme su contraseña',
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
        validator: (value) {
          if (passController.text != confirmPassController.text){
            return "Las contraseñas no coinciden";
          }
          return null;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        keyboardType: TextInputType.number,
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
          hintText: 'Afilie su tarjeta existente (opcional)',
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
        validator: (value){
          if (value!.isEmpty || value.length == 10){
            return null;
          }
          return "La tarjeta ingresada no es válida";
        },
        onSaved: (value){
          _tarjeta = value!;
        },
      )
    ]);
  }
}