import 'package:elimapass/services/tarjeta_service.dart';
import 'package:elimapass/widgets/DocumentsDialog.dart';
import 'package:elimapass/widgets/loading_foreground.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../../models/entities/Tarjeta.dart';

class TarjetaEspecialPage extends StatefulWidget {
  const TarjetaEspecialPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TarjetaEspecialPageState();
  }
}

class _TarjetaEspecialPageState extends State<TarjetaEspecialPage> {
  List<ImageFile> dni = [];
  List<ImageFile> carnet = [];
  bool loading = false;
  TarjetaService tarjetaService = TarjetaService();

  final controllerDni = MultiImagePickerController(
      maxImages: 2,
      picker: (allowMultiple) async {
        return await pickImagesUsingImagePicker(allowMultiple);
      });

  final controllerCarne = MultiImagePickerController(
      maxImages: 2,
      picker: (allowMultiple) async {
        return await pickImagesUsingImagePicker(allowMultiple);
      });

  void _submit() async {
    setState(() {
      loading = true;
    });
    dni = controllerDni.images.toList();
    carnet = controllerCarne.images.toList();
    ScaffoldMessenger.of(context).clearSnackBars();
    if (dni.length == 2 && carnet.length == 2) {
      try {
        Tarjeta? tarjeta = await tarjetaService.provider.getTarjeta();
        if (tarjeta == null) return;

        await tarjetaService.uploadSolicitud(
            dni: dni, carne: carnet, codigoTarjeta: tarjeta.id);

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const DocumentsDialog();
            });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sube las 4 fotos requeridas")),
      );
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Subir Documentos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Documento Nacional de Identidad (DNI)", // Ejemplo de fecha
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: MultiImagePickerView(
                      controller: controllerDni,
                      padding: const EdgeInsets.all(10),
                      builder: (BuildContext context, ImageFile imageFile) {
                        // here returning DefaultDraggableItemWidget. You can also return your custom widget as well.
                        return DefaultDraggableItemWidget(
                          imageFile: imageFile,
                          boxDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          closeButtonAlignment: Alignment.topLeft,
                          fit: BoxFit.cover,
                          closeButtonIcon: const Icon(Icons.delete_rounded,
                              color: Colors.red),
                          closeButtonBoxDecoration: null,
                          showCloseButton: true,
                          closeButtonMargin: const EdgeInsets.all(3),
                          closeButtonPadding: const EdgeInsets.all(3),
                        );
                      },
                      initialWidget: DefaultInitialWidget(
                        centerWidget: Icon(Icons.image_search_outlined),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.20),
                        margin: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const Text(
                    "Carnet Universitario", // Ejemplo de fecha
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: MultiImagePickerView(
                      controller: controllerCarne,
                      padding: const EdgeInsets.all(10),
                      builder: (BuildContext context, ImageFile imageFile) {
                        // here returning DefaultDraggableItemWidget. You can also return your custom widget as well.
                        return DefaultDraggableItemWidget(
                          imageFile: imageFile,
                          boxDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          closeButtonAlignment: Alignment.topLeft,
                          fit: BoxFit.cover,
                          closeButtonIcon: const Icon(Icons.delete_rounded,
                              color: Colors.red),
                          closeButtonBoxDecoration: null,
                          showCloseButton: true,
                          closeButtonMargin: const EdgeInsets.all(3),
                          closeButtonPadding: const EdgeInsets.all(3),
                        );
                      },
                      initialWidget: DefaultInitialWidget(
                        centerWidget: Icon(Icons.image_search_outlined),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.20),
                        margin: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                    child: const Text(
                      "Subir imágenes",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            if (loading) const LoadingForeground()
          ],
        ));
  }

  @override
  void dispose() {
    controllerDni.dispose();
    controllerCarne.dispose();
    super.dispose();
  }
}

Future<List<ImageFile>> pickImagesUsingImagePicker(bool allowMultiple) async {
  final picker = ImagePicker();
  final List<XFile> xFiles;
  if (allowMultiple) {
    xFiles = await picker.pickMultiImage(maxWidth: 1080, maxHeight: 1080);
  } else {
    xFiles = [];
    final xFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    if (xFile != null) {
      xFiles.add(xFile);
    }
  }
  if (xFiles.isNotEmpty) {
    return xFiles.map<ImageFile>((e) => convertXFileToImageFile(e)).toList();
  }
  return [];
}
