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

  static Future<String> patchPassword({required String password, required String new_password}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int id = prefs.getInt("userId")!;
      String accessToken = prefs.getString("accessToken")!;
      http.Response response = await http.patch(
          Uri.parse(Constants.userAPI+"/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token' : accessToken
          },
          body: jsonEncode({
            "password" : password,
            "new_password" : new_password
          })
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 400){
        switch (jsonDecode(response.body)["message"]){
          case "Wrong password":
            return "Podano błędne stare hasło";
        }
        return "Wystąpił nieoczekiwany błąd";
      }else if (response.statusCode == 200){
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

  static Future<String> putIngredient({required String name, required double calories, required double fats, required double carbs, required double proteins, required String unit}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString("accessToken")!;
      http.Response response = await http.put(
          Uri.parse(Constants.addIngredientAPI),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token' : accessToken
          },
          body: jsonEncode({
            "name" : name,
            "calories" : calories.toString(),
            "fats" : fats.toString(),
            "carbs" : carbs.toString(),
            "proteins" : proteins.toString(),
            "unit" : unit
          })
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 403){
        switch (jsonDecode(response.body)["message"]){
          case "Ingredient already exists":
            return "Składnik istnieje już w bazie wiedzy";
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
  static Future<String> sendArticle() async {
    String jsonText = jsonEncode([{"insert":"Lorem ipsum dolor sit amet","attributes":{"bold":true,"underline":true}},{"insert":"\n","attributes":{"header":1,"indent":22}},{"insert":"Consectetur adipiscing elit. Pellentesque congue odio vitae aliquet elementum. Nullam posuere nibh sapien, in suscipit lorem pellentesque at. Aliquam scelerisque nisi ex, efficitur tempus mauris fermentum sed. Nulla facilisi. Praesent urna tortor, fermentum id dolor in, cursus gravida urna. Maecenas in pretium massa. Donec in malesuada ligula. Donec faucibus libero ac arcu ultricies pulvinar. Nunc lobortis, odio sed consequat vulputate, velit tellus elementum justo, a varius velit est a sem. Sed nec scelerisque massa. In volutpat sollicitudin nibh. Proin pharetra","attributes":{"color":"#004d40"}},{"insert":" congue tempus. Curabitur facilisis eli","attributes":{"color":"#004d40","background":"#f44336","strike":true}},{"insert":"t vel hendrerit elementum. Praesent ultrices consequat luctus. Etiam mattis est nec enim facilisis ornare. Cras elementum, neque quis commodo condimentum, lacus erat bibendum massa, ac viverra ante sapien nec lorem.","attributes":{"color":"#004d40"}},{"insert":"\n"}]);
    try {
      String accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozLCJhZG1pbiI6ImZhbHNlIn0.sL6VKt8NA24Kod8BoqzlEJ46MoUTi3Cq5q5mHPm_tRc";
      http.Response response = await http.put(
          Uri.parse(Constants.articleAPI),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token' : accessToken
          },
        body: jsonEncode({
          "article_title" : "Testowy artykuł2",
          "article_content" : jsonText,
          "recipe_title" : "Testowy przepis",
          "recipe_content" : "Testowy content przepisu",
          "category" : "Obiady",
          "publication_date" : "2021-08-09"
        })
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

  static Future<String> getArticles({var filter, var sort, var search_title, var search_author, var amount, var start}) async {
    try {
      String params = "" +
          (filter != null ? "filter="+filter.toString()+"&" : "") +
          (sort != null ? "sort="+sort.toString()+"&" : "") +
          (search_title != null ? "search_title="+search_title.toString()+"&" : "") +
          (search_author != null ? "search_author="+search_author.toString()+"&" : "") +
          (amount != null ? "amount="+amount.toString()+"&" : "") +
          (start != null ? "start="+start.toString()+"&" : "");
      http.Response response = await http.get(
          Uri.parse("${Constants.getArticlesAPI}?$params"),
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

  static Future<String> getRecommendedArticles() async {
    try {
      http.Response response = await http.get(
        Uri.parse("${Constants.getRecommendedArticlesAPI}/5"),
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

  static Future<String> getRecipe({required int id}) async {
    try {
      http.Response response = await http.get(
        Uri.parse("${Constants.getRecipeAPI}/$id"),
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