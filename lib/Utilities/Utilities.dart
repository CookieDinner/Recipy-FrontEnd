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

  static List<String?> createRecipeStepsList(String steps) {
    List<String?> stepsList = [];
    var decodedSteps = jsonDecode(steps);
    for (var json in decodedSteps) {
      stepsList.add(json["insert"]);
    }
    return stepsList;
  }

  static String createRecipeStepsString(List<String?> stepsList) {
    List<Map<String, String?>> steps = [];
    for (String? step in stepsList) {
      steps.add({"insert" : step});
    }
    return jsonEncode(steps);
  }

  static Future<String?> getAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    return accessToken;
  }

  static Future<String?> getUsername() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("username");
    return username;
  }
}