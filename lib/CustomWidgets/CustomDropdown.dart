import 'package:flutter/material.dart';
import 'package:recipy/CustomWidgets/Popups/AddIngredientPopup.dart';
import 'package:recipy/CustomWidgets/Popups/ChangePasswordPopup.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomRoute.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Views/AddArticle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

class CustomDropdown {
  CustomDropdown();
  static Widget buildDropdown(BuildContext context, Size mediaSize, AsyncSnapshot<Object?> snapshot){
    return DropdownButtonHideUnderline(
      child: DropdownButton<Function>(
        itemHeight: 64,
        isExpanded: true,
        onChanged: (Function? func) {
          func!();
        },
        items: [
          DropdownMenuItem(
            value: (){
              Navigator.push(context, CustomRoute(AddArticle()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                SizedBox(
                  width: mediaSize.width * 0.052,
                  child: Text("Twoje artykuły",
                      style: Constants.textStyle(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          )
                      )
                  ),
                ),
                const Icon(Icons.article_outlined, size: 20, color: Colors.white,)
              ],
            ),
          ),
          DropdownMenuItem(
            value: (){
              debugPrint("your mom");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                SizedBox(
                  width: mediaSize.width * 0.052,
                  child: Text("Twoja szafka przepisów",
                      style: Constants.textStyle(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          )
                      )
                  ),
                ),
                const Icon(Icons.wallet_travel, size: 20, color: Colors.white,)
              ],
            ),
          ),
          DropdownMenuItem(
              value: () => AddIngredientPopup().showPopup(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  SizedBox(
                    width: mediaSize.width * 0.052,
                    child: Text("Zaproponuj nowy składnik",
                        style: Constants.textStyle(
                            textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                overflow: TextOverflow.clip
                            )
                        )
                    ),
                  ),
                  const Icon(Icons.post_add, size: 20, color: Colors.white,)
                ],
              )
          ),
          DropdownMenuItem(
            value: () => ChangePasswordPopup().showPopup(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                SizedBox(
                  width: mediaSize.width * 0.052,
                  child: Text("Zmień hasło",
                      style: Constants.textStyle(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          )
                      )
                  ),
                ),
                const Icon(Icons.lock_open, size: 20, color: Colors.white,)
              ],
            ),
          ),
          DropdownMenuItem(
              value: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("accessToken");
                prefs.remove("username");
                html.window.location.reload();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  SizedBox(
                    width: mediaSize.width * 0.052,
                    child: Text("Wyloguj się",
                        style: Constants.textStyle(
                            textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            )
                        )
                    ),
                  ),
                  const Icon(Icons.exit_to_app, size: 20, color: Colors.white,)
                ],
              )
          )
        ],
        dropdownColor: CustomTheme.buttonSecondary,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        hint: Center(
          child: SizedBox(
            width: mediaSize.width * 0.052,
            child: Text(
                snapshot.data as String,
                textAlign: TextAlign.center,
                style: Constants.textStyle(
                    textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    )
                )
            ),
          ),
        ),
        iconSize: mediaSize.width * 0.008,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,),
      ),
    );
  }
}