
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:recipy/CustomWidgets/ImageGallery.dart';
import 'package:recipy/Utilities/CustomTheme.dart';

class ImageDropper extends StatefulWidget {
  List<Uint8List> images;
  ImageDropper({required this.images, Key? key}) : super(key: key);

  @override
  _ImageDropperState createState() => _ImageDropperState();
}

class _ImageDropperState extends State<ImageDropper> {
  bool isHighlighted = false;
  bool showError = false;
  String errorText = "";
  late DropzoneViewController imageController;
  StreamController imageStreamController = StreamController<bool>();

  void resetError() {
    setState(() {
      showError = false;
      errorText = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            color: isHighlighted ? CustomTheme.buttonSecondary : showError ? Colors.red : CustomTheme.iconSelectedFill,
            height: 200,
            width: 300,
            child: Stack(
              children: [
                DropzoneView(
                  onCreated: (controller) => imageController = controller,
                  onDrop: acceptFile,
                  cursor: CursorType.grab,
                  onLeave: () => setState(() {
                    isHighlighted = false;
                  }),
                  onHover: () => setState((){
                    isHighlighted = true;
                  }),
                ),
                Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, size: 80, color: Colors.white,),
                        Text("Wrzuć zdjęcie tutaj", style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                        Text("Maksymalny rozmiar: 5MB\n Maksymalna liczba zdjęć: 6", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
                        !showError ? Container() : Text(errorText, style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                      ],
                    )
                )
              ],
            )
        ),
        ImageGallery(
          imageStreamController: imageStreamController,
          images: widget.images,
          resetError: resetError,
        )
      ],
    );
  }
  Future acceptFile(dynamic event) async {
    setState(() {
      isHighlighted = false;
    });
    final name = await imageController.getFilename(event);
    final bytes = await imageController.getFileData(event);
    final size = await imageController.getFileSize(event);
    final mime = await imageController.getFileMIME(event);
    if (mime != "image/jpeg" && mime != "image/png" && mime != "image/gif" && mime != "image/jpg"){
      setState(() {
        showError = true;
        errorText = "Podany plik nie jest zdjęciem!";
      });
      return;
    }
    if (size > 5000000) {
      setState(() {
        showError = true;
        errorText = "Podane zdjęcie jest zbyt duże!";
      });
      return;
    }
    print(widget.images.length);
    if (widget.images.length > 5) {
      setState(() {
        showError = true;
        errorText = "Osiągnięto maksymalną liczbę zdjęć!";
      });
      return;
    }
    setState(() {
      showError = false;
      errorText = "";
      widget.images.add(bytes);
      imageStreamController.add(true);
    });
  }
}
