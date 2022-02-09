import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipy/CustomWidgets/CustomTextbox.dart';
import 'package:recipy/CustomWidgets/Editor.dart';
import 'package:recipy/CustomWidgets/ImageDropper.dart';
import 'package:recipy/CustomWidgets/RecipeEditor.dart';
import 'package:recipy/CustomWidgets/Waves.dart';
import 'package:recipy/CustomWidgets/rNavBar.dart';
import 'package:recipy/Entities/Ingredient.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomRoute.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';
import 'package:recipy/Utilities/Utilities.dart';
import 'dart:html' as html;

import 'Home.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  final formKey = GlobalKey<FormState>();
  bool wasSubmitSuccessful = false;
  String? articleTitle;
  String? articleContent;
  String? category = null;
  bool isCategoryError = false;
  //Declared as a list instead of a simple string to pass it as a reference to RecipeEditor()
  List<String?> recipeTitle = [""];
  bool isSubmitButtonDisabled = false;
  List<Ingredient> addedIngredients = [];
  List<Ingredient> allIngredients = [];
  final ingredientsStreamController = StreamController<bool>();
  final addedIngredientsStreamController = StreamController<bool>();
  final stepsStreamController = StreamController<bool>();
  final categoriesStreamController = StreamController<bool>();
  List<String> categories = [];
  List<double> nutrition = [0, 0, 0, 0];
  List<String?> recipeSteps = [""];
  List<Uint8List> images = [];
  quill.QuillController quillController = quill.QuillController.basic();
  ScrollController scrollController = ScrollController();

  Future<void> getCategories() async {
    String response = await Requests.getCategories();
    for (Map<String, dynamic> category in jsonDecode(response)["data"]) {
      categories.add(category["name"]);
    }
    categoriesStreamController.add(true);
  }

  Future<void> getIngredients() async {
    ingredientsStreamController.add(false);
    String response = await Requests.getIngredients();
    dynamic decodedString = jsonDecode(response);
    for (Map<String, dynamic> ingredient in decodedString["data"]) {
      Ingredient parsedIngredient = Ingredient.fromJSON(ingredient);
      allIngredients.add(parsedIngredient);
    }
    ingredientsStreamController.add(true);
  }
  void calculateNutrition() {
    nutrition = [0, 0, 0, 0];
    for (Ingredient ingredient in addedIngredients) {
      nutrition[0] += ingredient.calories;
      nutrition[1] += ingredient.fats;
      nutrition[2] += ingredient.carbs;
      nutrition[3] += ingredient.proteins;
    }
    setState(() {});
  }
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await getIngredients();
      await getCategories();
    });
    stepsStreamController.add(true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // String jsonTextTest = "[{\"insert\":\"Lorem ipsum dolor sit amet\",\"attributes\":{\"bold\":true,\"underline\":true}},{\"insert\":\"\\n\",\"attributes\":{\"header\":1,\"indent\":22}},{\"insert\":\"Consectetur adipiscing elit. Pellentesque congue odio vitae aliquet elementum. Nullam posuere nibh sapien, in suscipit lorem pellentesque at. Aliquam scelerisque nisi ex, efficitur tempus mauris fermentum sed. Nulla facilisi. Praesent urna tortor, fermentum id dolor in, cursus gravida urna. Maecenas in pretium massa. Donec in malesuada ligula. Donec faucibus libero ac arcu ultricies pulvinar. Nunc lobortis, odio sed consequat vulputate, velit tellus elementum justo, a varius velit est a sem. Sed nec scelerisque massa. In volutpat sollicitudin nibh. Proin pharetra\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\" congue tempus. Curabitur facilisis eli\",\"attributes\":{\"color\":\"#004d40\",\"background\":\"#f44336\",\"strike\":true}},{\"insert\":\"t vel hendrerit elementum. Praesent ultrices consequat luctus. Etiam mattis est nec enim facilisis ornare. Cras elementum, neque quis commodo condimentum, lacus erat bibendum massa, ac viverra ante sapien nec lorem.\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\"\\n\"}]";
    // var json = jsonDecode(jsonTextTest);
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
                          padding: const EdgeInsets.fromLTRB(110, 110, 110, 0),
                          //Top page title
                          child: SizedBox(
                              child: Text("Nowy artykuł",
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
                        Container(height: 50, color: CustomTheme.secondaryBackground,),
                        //Whole article form
                        Container(
                          color: CustomTheme.secondaryBackground,
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        //Article title
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomTextbox(
                                                width: mediaSize.width * 0.25,
                                                maxLength: 64,
                                                padding: EdgeInsets.fromLTRB(32, 0, 64, 0),
                                                labelText: "Tytuł artykułu",
                                                validator: (value) {
                                                  if(value == null || value.isEmpty) {
                                                    return 'Tytuł artykułu nie może być pusty';
                                                  }
                                                  if(!RegExp(r"^[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ0-9 ]*$").hasMatch(value)) {
                                                    return 'Tylko litery i cyfry';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  articleTitle = value;
                                                },
                                                formKey: formKey
                                            ),
                                            StreamBuilder(
                                              stream: categoriesStreamController.stream,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const SizedBox(
                                                    height: 42,
                                                    width: 60,
                                                    child: Center(
                                                      child: SpinKitFadingCircle(
                                                        size: 30,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    height: 42,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: isCategoryError ? Colors.red : Colors.grey, width: 1))
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text("Kategoria:  ",
                                                          style: TextStyle(color: CustomTheme.text, fontSize: 16),),
                                                        DropdownButton<String>(
                                                          value: category,
                                                          onChanged: (value) =>
                                                              setState(() {
                                                                category = value!;
                                                                isCategoryError = false;
                                                              }),
                                                          items: categories.map((value) {
                                                            return DropdownMenuItem(
                                                              child: Text(value,
                                                                style: TextStyle(color: CustomTheme.textDark, fontSize: 16, fontWeight: FontWeight.w600),),
                                                              value: value,
                                                            );
                                                          }).toList(),
                                                          dropdownColor: CustomTheme.secondaryBackground,
                                                          iconSize: 12,
                                                          underline: Container(
                                                            color: Colors.transparent,
                                                            height: 0,),
                                                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                                                          hint: Center(
                                                            child: SizedBox(
                                                              width: 60,
                                                              height: 16,
                                                              child: Text("Wybierz", style: TextStyle(color: CustomTheme.text, fontSize: 14, fontWeight: FontWeight.w300),),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30,),
                                        //Article Editor
                                        Editor(mediaSize, quillController: quillController,),
                                      ],
                                    ),
                                    //Recipe Box
                                    RecipeEditor(
                                        mediaSize: mediaSize,
                                        recipeTitle: recipeTitle,
                                        formKey: formKey,
                                        addedIngredientsStreamController: addedIngredientsStreamController,
                                        ingredientsStreamController: ingredientsStreamController,
                                        stepsStreamController: stepsStreamController,
                                        addedIngredients: addedIngredients,
                                        allIngredients: allIngredients,
                                        recipeSteps: recipeSteps,
                                        calculateNutrition: calculateNutrition,
                                        nutrition: nutrition
                                    )
                                  ],
                                ),
                                SizedBox(height: 40,),
                                Text("Galeria zdjęć",
                                    style: Constants.textStyle(
                                        textStyle: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w500,
                                            color: CustomTheme.textDark,
                                        )
                                    )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(48.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ImageDropper(images: images),
                                    ],
                                  ),
                                ),
                                //Submit button
                                SizedBox(
                                  width: mediaSize.width * 0.15,
                                  height: 75,
                                  child: TextButton(
                                    onPressed: wasSubmitSuccessful ? () => Navigator.pushAndRemoveUntil(
                                      context,
                                      CustomRoute(Home()),
                                      ModalRoute.withName('/'),
                                    ) : isSubmitButtonDisabled ? null : () async {
                                      setState(() {
                                        isSubmitButtonDisabled = true;
                                      });
                                      if (formKey.currentState!.validate() && quillController.document.length <= 8000 && quillController.document.length > 1 && category != null){
                                        formKey.currentState!.save();
                                        articleContent = jsonEncode(quillController.document.toDelta().toJson());
                                        String steps = Utilities.createRecipeStepsString(recipeSteps);
                                        String response = await Requests.sendArticle(
                                            articleTitle: articleTitle!,
                                            articleContent: articleContent!,
                                            recipeTitle: recipeTitle[0]!,
                                            recipeContent: steps,
                                            category: category!,
                                            ingredients: addedIngredients,
                                            resources: images);
                                        setState(() {
                                          isCategoryError = false;
                                          if (response == "Good") {
                                            wasSubmitSuccessful = true;
                                          }
                                          isSubmitButtonDisabled = false;
                                        });
                                      } else {
                                        setState(() {
                                          if (category == null) {
                                            isCategoryError = true;
                                          }
                                          isSubmitButtonDisabled = false;
                                        });
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: wasSubmitSuccessful ? Colors.green : isSubmitButtonDisabled ? Colors.grey : CustomTheme.buttonSecondary
                                    ),
                                    child: Center(
                                      child: Text(
                                          wasSubmitSuccessful ? "ARTYKUŁ ZOSTAŁ WYSŁANY" : "WYŚLIJ ARTYKUŁ",
                                          style: Constants.textStyle(
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 48,),
                              ],
                            ),
                          ),
                        ),
                        //Footer
                        Container(
                          height: 60,
                          child: Card(
                            color: CustomTheme.background,
                            elevation: 20,
                            margin: EdgeInsets.zero,
                            child: Center(
                              child: Text("© 2021. Reci.py. All Rights Reserved",
                                style: Constants.textStyle(
                                    textStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: CustomTheme.footerText
                                    )
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          rNavBar(),
        ],
      ),
    );
  }
}
