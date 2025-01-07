import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white, // Change your back arrow color here
        ),
      ),
      body: Container(
        // Ensures the container fills the screen
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/background/bg1.png'), // Your background image
            fit: BoxFit.cover, // Ensures the image covers the entire screen
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20), // Adjust the radius for desired curve
                  child: Image.asset(
                    recipe.imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Recipe Title
              Text(
                recipe.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Cuisine Type
              Text(
                'Cuisine: ${recipe.cuisine}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              // Vegetarian/Vegan Tags
              Row(
                children: [
                  if (recipe.isVegetarian)
                    const Chip(label: Text('Vegetarian')),
                  const SizedBox(width: 8),
                  if (recipe.isVegan) const Chip(label: Text('Vegan')),
                  const SizedBox(width: 8),
                  if (recipe.isNonveg)
                    const Chip(label: Text('Non-Vegetarian')),
                ],
              ),
              const SizedBox(height: 16),
              // Ingredients
              const Text(
                'Ingredients:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              ...recipe.ingredients.map((ingredient) => Text(
                    '- $ingredient',
                    style: const TextStyle(color: Colors.white),
                  )),
              const SizedBox(height: 16),
              // Steps
              const Text(
                'Steps:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              ...recipe.steps.map((step) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '- $step',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
