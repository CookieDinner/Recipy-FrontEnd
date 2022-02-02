import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:recipy/CustomWidgets/Editor.dart';
import 'package:recipy/CustomWidgets/RecommendedArticles.dart';
import 'package:recipy/CustomWidgets/Waves.dart';
import 'package:recipy/CustomWidgets/rNavBar.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(110.0),
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
                      Waves(color1: CustomTheme.background, color2: CustomTheme.accent1,),
                      Waves(color1: CustomTheme.accent1, color2: CustomTheme.secondaryBackground,),
                      Editor(mediaSize),
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
            ],
          ),
          rNavBar(),
        ],
      ),
    );
  }
}
