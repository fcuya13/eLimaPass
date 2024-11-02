import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_credit_card/u_credit_card.dart';

import '../../widgets/PaymentDialog.dart';

class CreditDebitPage extends StatefulWidget {
  final double montoARecargar;
  const CreditDebitPage({super.key, required this.montoARecargar});

  @override
  State<StatefulWidget> createState() {
    return _CreditDebitPageState();
  }
}

class _CreditDebitPageState extends State<CreditDebitPage> {
  var _cardHolder = "";
  var _cardNumber = "";
  var _expDate = "";
  var _cvv = "";
  final _formKey = GlobalKey<FormState>();
  var loading = false;

  void _submit() async {
    setState(() {
      loading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      try {
        //await _loginService.login(_dni, _password);
        // pago

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const PaymentDialog();
            });
      } catch (e) {
        // Si la autenticación falla, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de autenticación: $e')),
        );
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 35,
          ),
          color: Colors.white,
        ),
        backgroundColor: const Color(0XFF405f90),
        title: const Text(
          "Recarga con tarjeta",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CreditCardUi(
                cardHolderFullName: _cardHolder.isEmpty ? "" : _cardHolder,
                cardNumber: _cardNumber.isEmpty ? "" : _cardNumber,
                validThru: _expDate.isEmpty ? "" : _expDate,
                cvvNumber: _cvv.isEmpty ? "" : _cvv,
                topLeftColor: Colors.blueAccent,
                bottomRightColor: Colors.lightBlueAccent,
                showValidFrom: false,
                doesSupportNfc: true,
                placeNfcIconAtTheEnd: true,
                cardProviderLogo: Image.asset(
                  'assets/visa.png',
                  width: 50,
                ),
                cardProviderLogoPosition: CardProviderLogoPosition.right,
                enableFlipping: true,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Número de tarjeta',
                        hintText: '1234 5678 9012 3456',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          _cardNumber = value;
                        });
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 16) {
                          return 'Ingrese un número de tarjeta válido';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Expiración',
                              hintText: 'MM/YY',
                            ),
                            keyboardType: TextInputType.datetime,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                              _CardExpiryInputFormatter(),
                            ],
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              setState(() {
                                _expDate = value;
                              });
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length != 5) {
                                return 'Ingrese una fecha';
                              }

                              if (!_validarExpDate(value)) {
                                return "Tarjeta vencida";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              hintText: '123',
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              setState(() {
                                _cvv = value;
                              });
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length != 3) {
                                return 'Ingrese un CVV válido';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nombre en tarjeta',
                        hintText: 'John Doe',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _cardHolder = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el nombre del dueño de la tarjeta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        fixedSize: const Size(300, 60),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _submit,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Realizar pago",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "S/.${widget.montoARecargar}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _validarExpDate(String value) {
    List<String> partes = value.split('/');
    String mes = partes[0];
    String anho = "20${partes[1]}";

    if (int.parse(mes) > 12) return false;

    if (int.parse(anho) > 2030) return false;

    DateTime fechaConvertida = DateTime.parse("$anho-$mes-01");

    DateTime fechaActual =
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    return fechaConvertida.isAfter(fechaActual) ||
        fechaConvertida.isAtSameMomentAs(fechaActual);
  }
}

class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length < 5) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}







//juan
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

import '../../widgets/PaymentDialog.dart';

class CreditDebitPage extends StatefulWidget {
  final double montoARecargar;
  const CreditDebitPage({super.key, required this.montoARecargar});

  @override
  State<StatefulWidget> createState() {
    return _CreditDebitPageState();
  }
}

class _CreditDebitPageState extends State<CreditDebitPage> {
  var _cardHolder = "";
  var _cardNumber = "";
  var _expDate = "";
  var _cvv = "";
  final _formKey = GlobalKey<FormState>();
  var loading = false;
  String? qrData;

  // Método para crear token de Culqi
  Future<String> _crearToken() async {
    final url = 'https://api.culqi.com/v2/tokens';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer TU_LLAVE_PRIVADA'
    };
    final body = jsonEncode({
      'card_number': _cardNumber,
      'cvv': _cvv,
      'expiration_month': _expDate.split('/')[0],
      'expiration_year': '20${_expDate.split('/')[1]}',
      'email': 'correo@ejemplo.com'
    });

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Error al crear el token: ${response.body}');
    }
  }

  // Método para crear cargo con Yape
  Future<void> _crearCargoYape(String token) async {
    final url = 'https://api.culqi.com/v2/charges';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer TU_LLAVE_PRIVADA'
    };
    final body = jsonEncode({
      'amount': (widget.montoARecargar * 100).toInt(),
      'currency_code': 'PEN',
      'email': 'correo@ejemplo.com',
      'source_id': token,
      'metadata': {'payment_method': 'yape'}
    });

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      setState(() {
        qrData = data['qr_data']; // Código QR para mostrar
      });
    } else {
      throw Exception('Error al crear el cargo: ${response.body}');
    }
  }

  void _submit() async {
    setState(() {
      loading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      try {
        final token = await _crearToken(); // Crea el token con Culqi
        await _crearCargoYape(token); // Crea el cargo con Yape y genera el QR

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return qrData != null
                  ? AlertDialog(
                      title: const Text('Escanea para pagar con Yape'),
                      content: QrImage(data: qrData!, size: 200),
                    )
                  : const PaymentDialog();
            });
      } catch (e) {
        // Si la autenticación falla, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de pago: $e')),
        );
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 35,
          ),
          color: Colors.white,
        ),
        backgroundColor: const Color(0XFF405f90),
        title: const Text(
          "Recarga con tarjeta",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CreditCardUi(
                cardHolderFullName: _cardHolder.isEmpty ? "" : _cardHolder,
                cardNumber: _cardNumber.isEmpty ? "" : _cardNumber,
                validThru: _expDate.isEmpty ? "" : _expDate,
                cvvNumber: _cvv.isEmpty ? "" : _cvv,
                topLeftColor: Colors.blueAccent,
                bottomRightColor: Colors.lightBlueAccent,
                showValidFrom: false,
                doesSupportNfc: true,
                placeNfcIconAtTheEnd: true,
                cardProviderLogo: Image.asset(
                  'assets/visa.png',
                  width: 50,
                ),
                cardProviderLogoPosition: CardProviderLogoPosition.right,
                enableFlipping: true,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Column(
                  children: [
                    // Aquí van los campos de tarjeta y el botón de pago
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _validarExpDate(String value) {
    List<String> partes = value.split('/');
    String mes = partes[0];
    String anho = "20${partes[1]}";

    if (int.parse(mes) > 12) return false;

    if (int.parse(anho) > 2030) return false;

    DateTime fechaConvertida = DateTime.parse("$anho-$mes-01");

    DateTime fechaActual =
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    return fechaConvertida.isAfter(fechaActual) ||
        fechaConvertida.isAtSameMomentAs(fechaActual);
  }
}

class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length < 5) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}












