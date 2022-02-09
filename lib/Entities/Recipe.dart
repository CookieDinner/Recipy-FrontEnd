
import 'Ingredient.dart';

class Recipe{
  late final int? id;
  late final int user_id;
  late final double? rating;
  late final String title;
  late final String content;
  late List<double> nutrition;
  late final List<Ingredient> ingredients;
  late bool? isInShelf;
  Recipe({this.id, required this.user_id, this.rating, required this.title, required this.content, this.ingredients = const [], this.isInShelf = false});
  Recipe.fromDetailed(Map<String, dynamic> recipe) {
    id = recipe["id"];
    user_id = recipe["user_id"];
    rating = recipe["rate"] ?? 0;
    title = recipe["title"];
    content = recipe["content"];
    isInShelf = false;
  }
  calculateNutrition() {
    nutrition = [0, 0, 0, 0];
    for (Ingredient ingredient in ingredients) {
      nutrition[0] += ingredient.calories;
      nutrition[1] += ingredient.fats;
      nutrition[2] += ingredient.carbs;
      nutrition[3] += ingredient.proteins;
    }
  }
}