import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipy/Utilities/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Requests{
  Requests();

  static Future<String> postLogin(String login, String password) async {
    try {
      http.Response response = await http.post(
          Uri.parse(Constants.loginAPI),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode({"login": login, "password": password})
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 404 || response.statusCode == 403){
        return "NotFound";
      }else{
        return jsonDecode(response.body)["token"];
      }
    }on SocketException{
      debugPrint("Connection failed");
      return "connfailed";
    }on TimeoutException{
      debugPrint("Timeout");
      return "conntimeout";
    }on HttpException{
      debugPrint("Http Exception");
      return "httpexception";
    }
  }

  static Future<String> putRegister({required String login, required String username, required String email, required String password, required String birth_date}) async {
    try {
      http.Response response = await http.put(
          Uri.parse(Constants.userAPI),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode({
            "login" : login,
            "password" : password,
            "email" : email,
            "username" : username,
            "birth_date" : birth_date
          })
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 403){
        switch (jsonDecode(response.body)["message"]){
          case "Email is already in use":
            return "Podany adres email jest już w użyciu";
          case "Login is already in use":
            return "Podany login jest już w użyciu";
        }
        return "Wystąpił nieoczekiwany błąd";
      }else if (response.statusCode == 201){
        return "Good";
      }else{
        return "Wystąpił nieoczekiwany błąd";
      }
    }on SocketException{
      debugPrint("Connection failed");
      return "Wystąpił błąd z połączeniem";
    }on TimeoutException{
      debugPrint("Timeout");
      return "Przekroczono limit połączenia";
    }on HttpException{
      debugPrint("Http Exception");
      return "Wystąpił błąd";
    }
  }

  static Future<String> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString("accessToken")!;
      http.Response response = await http.get(
          Uri.parse(Constants.myDataAPI),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token' : accessToken
          }
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 401){
        return "NotFound";
      }else{
        return response.body;
      }
    }on SocketException{
      debugPrint("Connection failed");
      return "connfailed";
    }on TimeoutException{
      debugPrint("Timeout");
      return "conntimeout";
    }on HttpException{
      debugPrint("Http Exception");
      return "httpexception";
    }
  }
}