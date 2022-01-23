import 'package:flutter/material.dart';

class Utilities{
  Utilities();

  static Size getDimensions(BuildContext context){
    return Size(
        MediaQuery.of(context).size.width -
            MediaQuery.of(context).padding.left -
            MediaQuery.of(context).padding.right,
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom);
  }
}