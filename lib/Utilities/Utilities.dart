import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static String decodeEditorText(String editorText){
    String cleanText = "";
    var textList = jsonDecode(editorText);
    for (var json in textList){
      cleanText += json["insert"].replaceAll("\n", " ");
    }
    return cleanText;
  }

  static Future<String?> getAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    return accessToken;
  }
}