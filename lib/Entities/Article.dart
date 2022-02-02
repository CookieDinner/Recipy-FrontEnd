
import 'package:recipy/Entities/Recipe.dart';

class Article{
  final int id;
  final int author_id;
  final String author;
  final double rating;
  final String date;
  final String category;
  final String title;
  final String content;
  final Recipe recipe;
  Article({required this.id, required this.author_id, required this.author, required this.category, required this.title, required this.content, required this.recipe, required this.rating, required this.date});
}