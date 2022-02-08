import 'dart:typed_data';

import 'package:recipy/Entities/Ingredient.dart';
import 'package:recipy/Entities/Recipe.dart';

class Article{
  late final int id;
  late final int author_id;
  late final String author;
  late final double rating;
  late final double userRating;
  late final String date;
  late final String category;
  late final String title;
  late final String content;
  late final Recipe recipe;
  late final bool isPublished;
  late final List<Uint8List> resources;
  Article({required this.id, required this.author_id, required this.author, required this.category, required this.title, required this.content, required this.recipe, required this.rating, required this.date});
  Article.fromGeneric(Map<String, dynamic> article){
    id = article["id"];
    author_id = article["author_id"];
    author = article["author"];
    rating = article["rate"] ?? 0;
    date = article["publication_date"];
    category = article["category"];
    title = article["title"];
    content = article["content"];
    recipe = Recipe(
        user_id: article["author_id"],
        title: article["recipe_title"],
        content: article["recipe_content"]
    );
  }
  Article.fromDetailed(Map<String, dynamic> article) {
    id = article["id"];
    author_id = article["author_id"];
    author = article["author"];
    rating = article["rate"] ?? 0;
    userRating = article["current_user_rate"] ?? 0;
    date = article["publication_date"];
    category = article["category"];
    title = article["title"];
    content = article["content"];
    List<Ingredient> temp_ingredients = [];
    for (dynamic ingredient in article["ingredients"]) {
      temp_ingredients.add(Ingredient(
          id: ingredient["id"],
          name: ingredient["name"],
          calories: ingredient["calories"],
          fats: ingredient["fats"],
          carbs: ingredient["carbs"],
          proteins: ingredient["proteins"],
          amount: ingredient["amount"],
          unit: ingredient["unit"]));
    }
    recipe = Recipe(
        user_id: article["author_id"],
        title: article["recipe_title"],
        content: article["recipe_content"],
        ingredients: temp_ingredients
    );
    isPublished = article["is_published"];
    // for (dynamic resource in article["resources"]) {
    //   resources.add(Uint8List.fromList(hex.decode(resource["bytes"])));
    // }
  }
}