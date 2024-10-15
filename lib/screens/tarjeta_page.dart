import 'package:elimapass/services/tarjeta_service.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';


class TarjetaPage extends StatefulWidget {
  const TarjetaPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TarjetaPageState();
  }
}

class _TarjetaPageState extends State<TarjetaPage> {
  bool _isWriting = false;
  final TarjetaService _tarjetaService = TarjetaService();

  @override
  void initState() {
    super.initState();
    _startNFCWriting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 10),
            child: Column(
              children: [
                const Icon(
                  Icons.wifi,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                Hero(
                  tag: 'tarjeta',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: const Image(
                      image: AssetImage('assets/lima_pass.jpg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40, // Ajuste de posición vertical del botón
            left: 10, // Ajuste de posición horizontal del botón
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white, // Color del ícono de retroceder
              ),
              onPressed: () {
                Navigator.pop(context); // Retrocede a la pantalla anterior
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startNFCWriting() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      String? tarjetaId = await _tarjetaService.provider.getTarjeta();

      if (tarjetaId == null) {
        throw ("Error inesperado");
      }

      if (isAvailable && !_isWriting) {
        _isWriting = true;
        await NfcManager.instance.startSession(
            onDiscovered: (NfcTag tag) async {
          try {
            NdefMessage message =
                NdefMessage([NdefRecord.createText(tarjetaId)]);
            await Ndef.from(tag)?.write(message);
            Uint8List payload = message.records.first.payload;
            String text = String.fromCharCodes(payload);
            debugPrint("Written data: $text");
            Navigator.pop(context);
          } catch (e) {
            debugPrint('Error emitting NFC data: $e');
          } finally {
            NfcManager.instance.stopSession();
            _isWriting = false;
          }
        });
      } else {
        debugPrint('NFC not available or already writing.');
      }
    } catch (e) {
      debugPrint('Error writing to NFC: $e');
    }
  }
}
