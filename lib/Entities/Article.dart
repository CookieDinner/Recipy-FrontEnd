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
}