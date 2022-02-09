
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipy/Entities/Ingredient.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';

import 'CustomTextbox.dart';

class RecipeEditor extends StatefulWidget {
  RecipeEditor({
      required this.mediaSize,
      required this.recipeTitle,
      required this.formKey,
      required this.addedIngredientsStreamController,
      required this.ingredientsStreamController,
      required this.stepsStreamController,
      required this.addedIngredients,
      required this.allIngredients,
      required this.recipeSteps,
      required this.calculateNutrition,
      required this.nutrition,
      Key? key
  }) : super(key: key);

  final mediaSize;
  List<String?> recipeTitle;
  GlobalKey<FormState> formKey;
  StreamController<bool> addedIngredientsStreamController;
  StreamController<bool> ingredientsStreamController;
  StreamController<bool> stepsStreamController;
  List<Ingredient> addedIngredients;
  List<Ingredient> allIngredients;
  List<String?> recipeSteps;
  Function calculateNutrition;
  List<double> nutrition;

  @override
  _RecipeEditorState createState() => _RecipeEditorState();
}

class _RecipeEditorState extends State<RecipeEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520,
      height: 1000,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)
        ),
        color: CustomTheme.art1,
        child: Column(
          children: [
            SizedBox(height: 30,),
            CustomTextbox(
                width: widget.mediaSize.width * 0.2,
                maxLength: 46,
                labelText: "Tytuł przepisu",
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Tytuł przepisu nie może być pusty';
                  }
                  if(!RegExp(r"^[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ0-9 ]*$").hasMatch(value)) {
                    return 'Tylko litery i cyfry';
                  }
                  return null;
                },
                onSaved: (value) {
                  widget.recipeTitle[0] = value;
                },
                formKey: widget.formKey
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Lista składników", style: Constants.textStyle(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.textDark)),),
                      SizedBox(height: 10,),
                      StreamBuilder(
                          stream: widget.addedIngredientsStreamController.stream,
                          builder: (context, snapshot) {
                            return Container(
                              height: 250,
                              width: 260,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: ListView.builder(
                                  controller: ScrollController(),
                                  itemCount: widget.addedIngredients.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 190,
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                              width: 140,
                                              child: Text(widget.addedIngredients[index].name, style: TextStyle(color: CustomTheme.textDark, fontSize: 11),)
                                          ),
                                          SizedBox(
                                            height: 60,
                                            child: CustomTextbox(
                                                mode: true,
                                                formKey: widget.formKey,
                                                width: 50,
                                                padding: EdgeInsets.zero,
                                                labelText: "",
                                                fontSize: 14,
                                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return "";
                                                  }
                                                  if(double.tryParse(value) == null) {
                                                    return "";
                                                  }
                                                },
                                                onSaved: (value) => widget.addedIngredients[index].amount = double.parse(value!)
                                            ),
                                          ),
                                          Container(
                                              width: 20,
                                              child: Text(widget.addedIngredients[index].unit, style: TextStyle(color: CustomTheme.textDark, fontSize: 11), textAlign: TextAlign.start,)
                                          ),
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  setState(() {
                                                    widget.allIngredients.add(widget.addedIngredients[index]);
                                                    widget.allIngredients.sort((a, b) => a.name.compareTo(b.name));
                                                    widget.addedIngredients.removeAt(index);
                                                    widget.calculateNutrition();
                                                    widget.addedIngredientsStreamController.add(true);
                                                  });
                                                },
                                                splashColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                icon: Icon(Icons.delete, color: CustomTheme.textDark,size: 16,)
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      StreamBuilder(
                          stream: widget.ingredientsStreamController.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox(
                                height: 80,
                                width: 80,
                                child: Center(
                                  child: SpinKitFadingCircle(
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                height: 40,
                                child: DropdownButton<Ingredient>(
                                  menuMaxHeight: 250,
                                  onChanged: (value) => setState(() {
                                    widget.addedIngredients.add(value!);
                                    widget.allIngredients.remove(value);
                                    widget.calculateNutrition();
                                    widget.addedIngredientsStreamController.add(true);
                                  }),
                                  items: widget.allIngredients.map((value) {
                                    return DropdownMenuItem(
                                      child: Container(
                                          width: 150,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  width: 110,
                                                  child: Text(value.name, style: TextStyle(color: CustomTheme.textDark, fontSize: 11),)
                                              ),
                                              Container(
                                                  width: 20,
                                                  child: Text(value.unit, style: TextStyle(color: CustomTheme.textDark, fontSize: 11), textAlign: TextAlign.end,)
                                              )
                                            ],
                                          )
                                      ),
                                      value: value,
                                    );
                                  }).toList(),
                                  dropdownColor: CustomTheme.secondaryBackground,
                                  iconSize: 12,
                                  underline: Container(
                                    color: Colors.grey,
                                    height: 1,),
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.grey,),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: CustomTheme.textDark,
                                  ),
                                  hint: Container(
                                    width: 150,
                                    child: Text("Dodaj składnik", style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: CustomTheme.textDark,
                                    ),),
                                  ),
                                ),
                              );
                            }
                          }
                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Wartości odżywcze na 100g", style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: CustomTheme.textDark,),
                            ),
                            Text("Kalorie: ${widget.nutrition[0]}", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: CustomTheme.textDark,),
                            ),
                            Text("Tłuszcze: ${widget.nutrition[1].toStringAsFixed(2)}g", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: CustomTheme.textDark,),
                            ),
                            Text("Węglowodany: ${widget.nutrition[2].toStringAsFixed(2)}g", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: CustomTheme.textDark,),
                            ),
                            Text("Białka: ${widget.nutrition[3].toStringAsFixed(2)}g", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: CustomTheme.textDark,),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text("Lista kroków", style: TextStyle(color: CustomTheme.textDark, fontSize: 16),),
            StreamBuilder(
                stream: widget.stepsStreamController.stream,
                builder: (context, snapshot) {
                  return Container(
                    height: 420,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)
                    ),
                    child: ListView.builder(
                        itemCount: widget.recipeSteps.length,
                        controller: ScrollController(),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                                child: Text((index + 1).toString() + ".", style: TextStyle(color: CustomTheme.textDark, fontSize: 16),),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                height: 60,
                                child: CustomTextbox(
                                    padding: EdgeInsets.zero,
                                    maxLength: 50,
                                    width: 400,
                                    mode: true,
                                    labelText: "",
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'Treść kroku nie może być pusta';
                                      }
                                      if(!RegExp(r"^[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ0-9,.-?! ]*$").hasMatch(value)) {
                                        return 'Tylko litery, cyfry i znaki interpunkcyjne';
                                      }
                                      return null;
                                    },
                                    onSaved: (value){
                                      widget.recipeSteps[index] = value;
                                    },
                                    formKey: widget.formKey),
                              ),
                              SizedBox(width: 20,),
                              index > 0 ? SizedBox(
                                height: 32,
                                width: 32,
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      widget.recipeSteps.removeAt(index);
                                      widget.stepsStreamController.add(true);
                                    },
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: Icon(Icons.delete, color: CustomTheme.textDark,size: 20,)
                                ),
                              ) : Container()
                            ],
                          );
                        }
                    ),
                  );
                }
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 120,
              height: 45,
              child: TextButton(
                onPressed: (){
                  widget.recipeSteps.add("");
                  widget.stepsStreamController.add(true);
                },
                style: TextButton.styleFrom(
                    backgroundColor: CustomTheme.buttonPrimary
                ),
                child: Center(
                  child: Text(
                      "Dodaj krok",
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
          ],
        ),
      ),
    );
  }
}
