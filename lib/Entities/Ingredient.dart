
class Ingredient{
  late final int id;
  late final String name;
  late final double calories;
  late final double fats;
  late final double carbs;
  late final double proteins;
  late final String unit;
  late double amount;

  Ingredient({required this.id, required this.name, required this.calories, required this.fats, required this.carbs,
    required this.proteins, required this.unit, this.amount = 0});

  Ingredient.fromJSON(Map<String, dynamic> ingredient) {
    id = ingredient["id"];
    name = ingredient["name"];
    calories = ingredient["calories"];
    fats = ingredient["fats"];
    carbs = ingredient["carbs"];
    proteins = ingredient["proteins"];
    unit = ingredient["unit"];
  }
}