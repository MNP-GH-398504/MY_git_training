class Recipe {
  final String title;
  final String imageUrl;
  final String cuisine;
  final bool isVegetarian;
  final bool isVegan;
  final bool isNonveg;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.cuisine,
    required this.isVegetarian,
    required this.isVegan,
    required this.isNonveg,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      imageUrl: json['imageUrl'],
      cuisine: json['cuisine'],
      isVegetarian: json['isVegetarian'],
      isVegan: json['isVegan'],
      isNonveg: json['isNonveg'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
    );
  }
}
