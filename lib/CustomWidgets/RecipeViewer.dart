
import 'package:flutter/material.dart';
import 'package:recipy/Entities/Recipe.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';
import 'package:recipy/Utilities/Utilities.dart';

class RecipeViewer extends StatefulWidget {
  const RecipeViewer(this.recipe, {this.hasAddButton = true, Key? key}) : super(key: key);
  final Recipe recipe;
  final bool hasAddButton;
  @override
  _RecipeViewerState createState() => _RecipeViewerState();
}

class _RecipeViewerState extends State<RecipeViewer> {
  late List<String?> steps;
  bool isShelfButtonDeactivated = false;
  @override
  void initState() {
    widget.recipe.calculateNutrition();
    steps = Utilities.createRecipeStepsList(widget.recipe.content);
    super.initState();
  }
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
            Text(widget.recipe.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: CustomTheme.textDark),),
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
                      Container(
                        height: 250,
                        width: 260,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)
                        ),
                        child: ListView.builder(
                            controller: ScrollController(),
                            itemCount: widget.recipe.ingredients.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 190,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 140,
                                        child: Text(widget.recipe.ingredients[index].name, style: TextStyle(color: CustomTheme.textDark, fontSize: 11),)
                                    ),
                                    SizedBox(
                                      height: 20,
                                      child: Center(child: Text(widget.recipe.ingredients[index].amount.toStringAsFixed(2), style: TextStyle(color: CustomTheme.textDark, fontSize: 11)))
                                    ),
                                    Container(
                                        width: 20,
                                        child: Text(widget.recipe.ingredients[index].unit, style: TextStyle(color: CustomTheme.textDark, fontSize: 11), textAlign: TextAlign.start,)
                                    ),
                                  ],
                                ),
                              );
                            }
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
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
                            Text("Kalorie: ${widget.recipe.nutrition[0]}", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: CustomTheme.textDark,),
                            ),
                            Text("Tłuszcze: ${widget.recipe.nutrition[1].toStringAsFixed(2)}g", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: CustomTheme.textDark,),
                            ),
                            Text("Węglowodany: ${widget.recipe.nutrition[2].toStringAsFixed(2)}g", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: CustomTheme.textDark,),
                            ),
                            Text("Białka: ${widget.recipe.nutrition[3].toStringAsFixed(2)}g", style: TextStyle(
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
            Container(
              height: 420,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1)
              ),
              child: ListView.builder(
                  itemCount: steps.length,
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 0, 0),
                          child: Text((index + 1).toString() + ".  " + steps[index]!, style: TextStyle(color: CustomTheme.textDark, fontSize: 18),),
                        ),
                      ],
                    );
                  }
              ),
            ),
            SizedBox(height: 20),
            widget.hasAddButton && widget.recipe.isInShelf != null ? SizedBox(
              width: 200,
              height: 45,
              child: TextButton(
                onPressed: isShelfButtonDeactivated ? null : () async{
                  setState(() {
                    isShelfButtonDeactivated = true;
                  });
                  String response = widget.recipe.isInShelf! ? await Requests.removeRecipeFromShelf(widget.recipe) : await Requests.addRecipeToShelf(widget.recipe);
                  if (response == "Good") {
                    setState(() {
                      widget.recipe.isInShelf = !(widget.recipe.isInShelf!);
                    });
                  }
                  setState(() {
                    isShelfButtonDeactivated = false;
                  });
                },
                style: TextButton.styleFrom(
                    backgroundColor: isShelfButtonDeactivated ? Colors.grey : widget.recipe.isInShelf! ? Colors.red : CustomTheme.buttonPrimary
                ),
                child: Center(
                  child: Text(
                      widget.recipe.isInShelf! ? "Usuń przepis z szafki" : "Dodaj przepis do szafki",
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
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
