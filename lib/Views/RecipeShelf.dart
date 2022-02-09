
import 'dart:async';
import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipy/CustomWidgets/Footer.dart';
import 'package:recipy/CustomWidgets/NavigationButtons.dart';
import 'package:recipy/CustomWidgets/RecipesList.dart';
import 'package:recipy/CustomWidgets/Waves.dart';
import 'package:recipy/CustomWidgets/rNavBar.dart';
import 'package:recipy/Entities/Ingredient.dart';
import 'package:recipy/Entities/Recipe.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';
import 'package:recipy/Utilities/Utilities.dart';

class RecipeShelf extends StatefulWidget {
  const RecipeShelf({Key? key}) : super(key: key);

  @override
  _RecipeShelfState createState() => _RecipeShelfState();
}

class _RecipeShelfState extends State<RecipeShelf> {
  StreamController<bool> recipesStreamController = StreamController<bool>();
  List<Recipe> recipes = [];
  int? numberOfPages;
  int currentPage = 1;
  ScrollController scrollController = ScrollController();

  Future<void> getRecipes() async {
    recipes.clear();
    String response = await Requests.getMyRecipesInShelf();
    for (Map<String, dynamic> recipe in jsonDecode(response)["data"]) {
      List<Ingredient> temp_ingredients = [];
      for (dynamic ingredient in recipe["ingredients"]) {
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
      recipes.add(Recipe(
          id: recipe["id"],
          user_id: recipe["user_id"],
          title: recipe["title"],
          content: recipe["content"],
          ingredients: temp_ingredients,
          rating: recipe["rate"],
      ));
    }
    recipesStreamController.add(true);
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    recipesStreamController.add(false);
    await Requests.removeRecipeFromShelf(recipe);
    await getRecipes();
    recipesStreamController.add(true);
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await getRecipes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = Utilities.getDimensions(context);
    return Scaffold(
      backgroundColor: CustomTheme.background,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: AdaptiveScrollbar(
                  underColor: CustomTheme.secondaryBackground,
                  underDecoration: BoxDecoration(
                      color: CustomTheme.secondaryBackground,
                      border: Border.all(
                          color: CustomTheme.iconSelectedFill,
                          width: 1
                      )
                  ),
                  sliderSpacing: EdgeInsets.zero,
                  sliderDefaultColor: CustomTheme.iconSelectedFill,
                  sliderActiveColor: CustomTheme.buttonPrimary,
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 110, 0, 0),
                          child: Column(
                            children: [
                              SizedBox(
                                  child: Text("Szafka przepisów",
                                    style: Constants.textStyle(
                                        textStyle: TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold,
                                            color: CustomTheme.text,
                                            height: 2
                                        )
                                    ),
                                  )
                              ),
                              Stack(
                                children: [
                                  SizedBox(
                                      height: 100,
                                      child: Waves(color1: CustomTheme.background, color2: CustomTheme.accent1,)
                                  ),
                                  Positioned(
                                    left: mediaSize.width * 0.18,
                                    bottom: 15,
                                    child: Image.asset('assets/images/tree.png', height: 65,),
                                  ),
                                  Positioned(
                                    left: mediaSize.width * 0.207,
                                    bottom: 15,
                                    child: Image.asset('assets/images/tree.png', height: 35,),
                                  ),
                                  Positioned(
                                    left: mediaSize.width * 0.227,
                                    bottom: 18,
                                    child: Image.asset('assets/images/tree.png', height: 45,),
                                  ),
                                  Positioned(
                                    right: mediaSize.width * 0.195,
                                    bottom: 0,
                                    child: Image.asset('assets/images/tree.png', height: 90,),
                                  ),
                                ],
                              ),
                              Waves(color1: CustomTheme.accent1, color2: CustomTheme.secondaryBackground,),
                              Container(
                                width: mediaSize.width,
                                height: 900,
                                color: CustomTheme.secondaryBackground,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 32,),
                                    Container(
                                      height: mediaSize.width * 0.45,
                                      width: mediaSize.width * 0.75,
                                      color: CustomTheme.art1,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20,),
                                          StreamBuilder(
                                              stream: recipesStreamController.stream,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return SizedBox(
                                                    height: mediaSize.width * 0.38,
                                                    width: mediaSize.width * 0.70,
                                                    child: const Center(
                                                      child: SpinKitFadingCircle(
                                                        size: 80,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                    if (snapshot.data == false) {
                                                      return SizedBox(
                                                        height: mediaSize.width * 0.38,
                                                        width: mediaSize.width * 0.70,
                                                        child: const Center(
                                                          child: SpinKitFadingCircle(
                                                            size: 80,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          SizedBox(height: 20,),
                                                          RecipesList(mediaSize, recipes, deleteRecipe)
                                                        ],
                                                      );
                                                    }
                                                }
                                              }
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Footer()
                            ],
                          ),
                        )
                      ]
                    ),
                  )
                )
              )
            ],
          ),
          rNavBar()
        ],
      ),
    );
  }
}
