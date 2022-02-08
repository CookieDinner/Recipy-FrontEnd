
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePopup{
  void showPopup(BuildContext context, Uint8List image){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: 720,
              width: 1280,
              child: Stack(
                children: [
                  Center(
                    child: Image.memory(image),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: IconButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.close, color: Colors.white, size: 32,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}