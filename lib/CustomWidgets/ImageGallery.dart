
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recipy/CustomWidgets/Popups/ImagePopup.dart';
import 'package:recipy/Utilities/CustomTheme.dart';

class ImageGallery extends StatefulWidget {
  StreamController imageStreamController;
  List<Uint8List> images;
  bool canDelete;
  Function? resetError;
  ImageGallery({required this.imageStreamController, required this.images, this.canDelete = false, this.resetError, Key? key}) : super(key: key);

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.imageStreamController.stream,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: CustomTheme.text, width: 2),
            ),
            height: 200,
            width: 1500,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                itemBuilder: (context, index){
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        height: 130,
                        width: 233,
                        child: Stack(
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => ImagePopup().showPopup(context, widget.images[index]),
                                child: Container(
                                  height: 130,
                                  width: 233,
                                  child: Center(child: Image.memory(widget.images[index])),
                                ),
                              ),
                            ),
                            widget.canDelete ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: IconButton(
                                    onPressed: (){
                                      widget.images.removeAt(index);
                                      widget.imageStreamController.add(true);
                                      if (widget.resetError != null) {
                                        widget.resetError!();
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.close, color: Colors.red, size: 32,),
                                  ),
                                ),
                              ],
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
    );
  }
}
