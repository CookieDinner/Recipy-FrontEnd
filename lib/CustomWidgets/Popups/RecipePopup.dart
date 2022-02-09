
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipy/CustomWidgets/RecipeViewer.dart';
import 'package:recipy/Entities/Recipe.dart';
import 'package:recipy/Utilities/CustomTheme.dart';

class RecipePopup{
  void showPopup(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Stack(
            children: [
              RecipeViewer(recipe, hasAddButton: false,),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.close, color: CustomTheme.art1, size: 32,),
                      ),
                    ),
                    SizedBox(width: 15,)
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}