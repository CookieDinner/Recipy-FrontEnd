
import 'package:flutter/material.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';

import 'LoginPopup.dart';

class DeletePromptPopup {
  bool confirm = false;
  Future<bool> showPopup(BuildContext context, String choice) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                backgroundColor: CustomTheme.secondaryBackground,
                content: SizedBox(
                  height: 210,
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                              return;
                            },
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.close, color: CustomTheme.textDark,),
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Text("Czy na pewno chcesz usunąć wybrany $choice?\nTej operacji nie można cofnąć!",
                        textAlign: TextAlign.center,
                        style: Constants.textStyle(
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CustomTheme.text,
                                height: 0
                            )
                        ),
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 130,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: CustomTheme.buttonSecondary
                                ),
                                child: Text(
                                    "TAK",
                                    style: Constants.textStyle(
                                        textStyle: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                        )
                                    )
                                ),
                                onPressed: () {
                                  setState(() => confirm = true);
                                  Navigator.of(context).pop();
                                  return;
                                }
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 130,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: CustomTheme.buttonSecondary
                                ),
                                child: Text(
                                    "NIE",
                                    style: Constants.textStyle(
                                        textStyle: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                        )
                                    )
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  return;
                                }
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
          }
        );
      }
    );
    return confirm;

  }
}