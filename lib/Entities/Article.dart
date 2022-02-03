import 'package:intl/intl.dart';
import 'package:recipy/Entities/Recipe.dart';
import 'package:recipy/Utilities/Requests.dart';

class Article{
  late final int id;
  late final int author_id;
  late final String author;
  late final double rating;
  late final String date;
  late final String category;
  late final String title;
  late final String content;
  late final Recipe recipe;
  Article({required this.id, required this.author_id, required this.author, required this.category, required this.title, required this.content, required this.recipe, required this.rating, required this.date});
  Article.fromMaps(Map<String, dynamic> article, Map<String, dynamic> recipe){
    id = article["id"];
    author_id = article["author_id"];
    author = article["author"];
    rating = article["rate"] ?? 0;
    date = article["publication_date"];
    category = article["category"];
    title = article["title"];
    content = article["content"];
    this.recipe = parseRecipe(recipe);
  }

  Recipe parseRecipe(Map<String, dynamic> recipe) {
    return Recipe(id: recipe["id"], user_id: recipe["user_id"], rating: recipe["rate"] ?? 0, title: recipe["title"], content: recipe["content"]);
  }
}