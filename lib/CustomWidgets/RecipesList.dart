
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipy/CustomWidgets/Popups/RecipePopup.dart';
import 'package:recipy/Entities/Recipe.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';

import 'Popups/DeletePromptPopup.dart';

class RecipesList extends StatefulWidget {
  final Size mediaSize;
  final List<Recipe> recipes;
  final Function deleteRecipe;
  const RecipesList(this.mediaSize, this.recipes, this.deleteRecipe, {Key? key}) : super(key: key);

  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.mediaSize.width * 0.38,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 100,
            ),
            itemCount: widget.recipes.length,
            itemBuilder: (context, index) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => RecipePopup().showPopup(context, widget.recipes[index]),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    color: CustomTheme.art5,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 64,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: 64,
                                            width: 160,
                                            child: Text(widget.recipes[index].title, style: Constants.textStyle(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: CustomTheme.textDark))),
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.utensils,
                                            color: CustomTheme.textDark.withOpacity(0.7),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 260,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    if(await DeletePromptPopup().showPopup(context, "przepis")) {
                                      widget.deleteRecipe(widget.recipes[index]);
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.close, color: Colors.red, size: 20,),
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
