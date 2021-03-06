import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipy/Entities/Article.dart';
import 'package:recipy/Entities/Ingredient.dart';
import 'package:recipy/Entities/Recipe.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convert/convert.dart';

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
            return "Podany adres email jest ju?? w u??yciu";
          case "Login is already in use":
            return "Podany login jest ju?? w u??yciu";
        }
        return "Wyst??pi?? nieoczekiwany b????d";
      }else if (response.statusCode == 201){
        return "Good";
      }else{
        return "Wyst??pi?? nieoczekiwany b????d";
      }
    }on SocketException{
      debugPrint("Connection failed");
      return "Wyst??pi?? b????d z po????czeniem";
    }on TimeoutException{
      debugPrint("Timeout");
      return "Przekroczono limit po????czenia";
    }on HttpException{
      debugPrint("Http Exception");
      return "Wyst??pi?? b????d";
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
            return "Podano b????dne stare has??o";
        }
        return "Wyst??pi?? nieoczekiwany b????d";
      }else if (response.statusCode == 200){
        return "Good";
      }else{
        return "Wyst??pi?? nieoczekiwany b????d";
      }
    }on SocketException{
      debugPrint("Connection failed");
      return "Wyst??pi?? b????d z po????czeniem";
    }on TimeoutException{
      debugPrint("Timeout");
      return "Przekroczono limit po????czenia";
    }on HttpException{
      debugPrint("Http Exception");
      return "Wyst??pi?? b????d";
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
            return "Sk??adnik istnieje ju?? w bazie wiedzy";
        }
        return "Wyst??pi?? nieoczekiwany b????d";
      }else if (response.statusCode == 201){
        return "Good";
      }else{
        return "Wyst??pi?? nieoczekiwany b????d";
      }
    }on SocketException{
      debugPrint("Connection failed");
      return "Wyst??pi?? b????d z po????czeniem";
    }on TimeoutException{
      debugPrint("Timeout");
      return "Przekroczono limit po????czenia";
    }on HttpException{
      debugPrint("Http Exception");
      return "Wyst??pi?? b????d";
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
  static Future<String> sendArticle({required String articleTitle, required String articleContent, required String recipeTitle,
      required String recipeContent, required String category, required List<Ingredient> ingredients, required List<Uint8List> resources}) async {
    List<Map<String, dynamic>> builtIngredients = [];
    List<Map<String, dynamic>> builtResources = [];
    for (Ingredient ingredient in ingredients) {
      builtIngredients.add({"ingredient_id" : ingredient.id.toString(), "amount" : ingredient.amount.toString()});
    }
    for (Uint8List resource in resources) {
      builtResources.add({"bytes" : base64.encode(resource)});
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString("accessToken")!;
      http.Response response = await http.put(
          Uri.parse(Constants.articleAPI),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token' : accessToken
          },
        body: jsonEncode({
          "article_title" : articleTitle,
          "article_content" : articleContent,
          "recipe_title" : recipeTitle,
          "recipe_content" : recipeContent,
          "category" : category,
          "ingredients" : builtIngredients,
          "resources" : builtResources
        })
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 401){
        return "NotFound";
      }else{
        if (response.statusCode == 201) {
          return "Good";
        } else {
          return "Fail";
        }
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

  static Future<String> getArticles({var filter, var sort, var search_title, var search_author, var amount, var start, var category}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString("accessToken");
      String params = "" +
          (filter != null ? "filter="+filter.toString()+"&" : "") +
          (sort != null ? "sort="+sort.toString()+"&" : "") +
          (search_title != null ? "search_title="+search_title.toString()+"&" : "") +
          (search_author != null ? "search_author="+search_author.toString()+"&" : "") +
          (amount != null ? "amount="+amount.toString()+"&" : "") +
          (category != null ? "category="+category.toString()+"&" : "") +
          (start != null ? "start="+start.toString()+"&" : "");
      http.Response response = await http.get(
          Uri.parse("${Constants.getArticlesAPI}?$params"),
        headers: accessToken != null ? {
            "x-access-token" : accessToken
        } : {}
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

  static Future<String> getArticle(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    try {
      http.Response response = await http.get(
        Uri.parse("${Constants.getArticleAPI}/$id"),
        headers: accessToken != null ? <String, String>{
          'x-access-token' : accessToken
        } : <String, String> {}
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

  static Future<String> getCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse("${Constants.getCategoriesAPI}"),
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

  static Future<String> getIngredients() async {
    try {
      http.Response response = await http.get(
        Uri.parse("${Constants.getIngredientsAPI}"),
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

  static Future<String> rateArticle(Article article, double newRating) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString("accessToken")!;
      http.Response response = await http.post(
          Uri.parse(Constants.postRatingAPI),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token' : accessToken
          },
        body: jsonEncode({
          "rate" : newRating.toStringAsFixed(2),
          "rated" : article.id.toString()
        })
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 401){
        return "NotFound";
      }else{
        if (response.statusCode == 200) {
          return response.body;
        } else {
          return "Idk";
        }
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

  static Future<String> deleteArticle(int articleId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString("accessToken")!;
      http.Response response = await http.delete(
          Uri.parse("${Constants.articleAPI}/$articleId"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token' : accessToken
          },

      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 401){
        return "NotFound";
      }else{
        if (response.statusCode == 200) {
          return "Good";
        } else {
          return "Idk";
        }
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

  static Future<String> addRecipeToShelf(Recipe recipe) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString("accessToken")!;
      http.Response response = await http.post(
          Uri.parse("${Constants.postSaveRecipeAPI}/${recipe.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token' : accessToken
          },
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 401){
        return "NotFound";
      }else{
        if (response.statusCode == 200) {
          return "Good";
        } else {
          return "Idk";
        }
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

  static Future<String> removeRecipeFromShelf(Recipe recipe) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString("accessToken")!;
      http.Response response = await http.delete(
        Uri.parse("${Constants.deleteRemoveRecipeAPI}/${recipe.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token' : accessToken
        },
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 401){
        return "NotFound";
      }else{
        if (response.statusCode == 200) {
          return "Good";
        } else {
          return "Idk";
        }
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

  static Future<String> getMyRecipesInShelf() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString("accessToken")!;
      http.Response response = await http.get(
        Uri.parse(Constants.getMySavedRecipesAPI),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token' : accessToken
        },
      ).timeout(const Duration(seconds: Constants.timeoutTime));
      if (response.statusCode == 401){
        return "NotFound";
      }else{
        if (response.statusCode == 200) {
          return response.body;
        } else {
          return "Idk";
        }
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