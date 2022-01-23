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

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
                        child: Column(
                          children: [
                            SizedBox(
                              child: Text("Reci.py",
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
                            SizedBox(
                              width: mediaSize.width * 0.23,
                              child: Text("Serwis dedykowany wszystkim osobom chcącym podzielić się "
                                  "swoimi kulinarnymi przygodami lub znaleźć interesujące nowe "
                                  "przepisy do przygotowania.",
                                style: Constants.textStyle(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: CustomTheme.text,
                                      height: 2
                                  ),
                                ), textAlign: TextAlign.center,
                              ),
                            )
                          ],
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
                      Container(
                        height: mediaSize.width * 0.35,
                        width: mediaSize.width,
                        color: CustomTheme.secondaryBackground,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40,),
                            Text("Polecane artykuły", style: Constants.textStyle(
                              textStyle: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                                color: CustomTheme.text
                              )
                            ),),
                            const SizedBox(height: 40,),
                            RecommendedArticles(mediaSize),
                          ],
                        ),
                      ),
                      Waves(color1: CustomTheme.secondaryBackground, color2: CustomTheme.accent2,),
                      Waves(color1: CustomTheme.accent2, color2: CustomTheme.tertiaryBackground,),
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