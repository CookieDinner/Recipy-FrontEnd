
class Recipe{
  late final int? id;
  late final int user_id;
  late final double? rating;
  late final String title;
  late final String content;
  Recipe({this.id, required this.user_id, this.rating, required this.title, required this.content});
  Recipe.fromDetailed(Map<String, dynamic> recipe) {
    id = recipe["id"];
    user_id = recipe["user_id"];
    rating = recipe["rate"] ?? 0;
    title = recipe["title"];
    content = recipe["content"];
  }
}