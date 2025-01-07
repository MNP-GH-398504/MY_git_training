import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_app/screens/recipeDetails.dart';
import '../models/recipe.dart';
import 'filter.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({Key? key}) : super(key: key);

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late Future<List<Recipe>> allRecipes;
  List<Recipe> filteredRecipes = [];
  List<Recipe> searchedRecipes = [];
  Map<String, bool> filters = {
    'isVegetarian': false,
    'isVegan': false,
    'isNonveg': false,
  };

  String searchQuery = '';
  bool isSearching = false;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  Future<List<Recipe>> _loadRecipes() async {
    final String response =
        await rootBundle.loadString('assets/data/recipes.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Recipe.fromJson(json)).toList();
  }

  void _applyFilters(Map<String, bool> selectedFilters) {
    setState(() {
      filters = selectedFilters;
      _filterRecipes();
    });
  }

  void _filterRecipes() {
    allRecipes.then((recipes) {
      setState(() {
        filteredRecipes = recipes.where((recipe) {
          if (filters['isVegetarian'] == true && !recipe.isVegetarian) {
            return false;
          }
          if (filters['isVegan'] == true && !recipe.isVegan) {
            return false;
          }
          if (filters['isNonveg'] == true && !recipe.isNonveg) {
            return false;
          }
          return true;
        }).toList();
        _searchRecipes(searchQuery);
      });
    });
  }

  void _searchRecipes(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        searchedRecipes = filteredRecipes;
      } else {
        searchedRecipes = filteredRecipes
            .where((recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    allRecipes = _loadRecipes();
    allRecipes.then((recipes) {
      setState(() {
        filteredRecipes = recipes;
        searchedRecipes = recipes;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5, // Half the screen height
          child: FilterScreen(
            filters: filters,
            onApplyFilters: _applyFilters,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                focusNode: _focusNode,
                controller: _searchController,
                onChanged: _searchRecipes,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search Recipes...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
              )
            : const Text(
                'Recipe',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search_rounded),
            color: Colors.white,
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (isSearching) {
                  _focusNode.requestFocus(); // Focus the text field
                } else {
                  _focusNode.unfocus(); // Unfocus the text field
                  _searchController.clear();
                  _searchRecipes(''); // Reset search
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded, color: Colors.white),
            onPressed: _openFilterPanel, // Open the half-screen panel
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/background/bg3.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<List<Recipe>>(
            future: allRecipes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'An error occurred while loading recipes:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (searchedRecipes.isEmpty) {
                return const Center(
                  child: Text(
                    'No recipe',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.builder(
                itemCount: searchedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = searchedRecipes[index];
                  return ListTile(
                    leading: ClipOval(
                      child: Image.asset(
                        recipe.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      recipe.title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(
                      recipe.cuisine,
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
