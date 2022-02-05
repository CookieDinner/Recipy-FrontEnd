import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
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
import 'package:flutter_quill/flutter_quill.dart' as quill;

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    String jsonTextTest = "[{\"insert\":\"Lorem ipsum dolor sit amet\",\"attributes\":{\"bold\":true,\"underline\":true}},{\"insert\":\"\\n\",\"attributes\":{\"header\":1,\"indent\":22}},{\"insert\":\"Consectetur adipiscing elit. Pellentesque congue odio vitae aliquet elementum. Nullam posuere nibh sapien, in suscipit lorem pellentesque at. Aliquam scelerisque nisi ex, efficitur tempus mauris fermentum sed. Nulla facilisi. Praesent urna tortor, fermentum id dolor in, cursus gravida urna. Maecenas in pretium massa. Donec in malesuada ligula. Donec faucibus libero ac arcu ultricies pulvinar. Nunc lobortis, odio sed consequat vulputate, velit tellus elementum justo, a varius velit est a sem. Sed nec scelerisque massa. In volutpat sollicitudin nibh. Proin pharetra\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\" congue tempus. Curabitur facilisis eli\",\"attributes\":{\"color\":\"#004d40\",\"background\":\"#f44336\",\"strike\":true}},{\"insert\":\"t vel hendrerit elementum. Praesent ultrices consequat luctus. Etiam mattis est nec enim facilisis ornare. Cras elementum, neque quis commodo condimentum, lacus erat bibendum massa, ac viverra ante sapien nec lorem.\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\"\\n\"}]";
    var json = jsonDecode(jsonTextTest);
    quill.QuillController quillController = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
    );

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
                        Container(height: 50, color: CustomTheme.secondaryBackground,),
                        Container(
                          color: CustomTheme.secondaryBackground,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Editor(mediaSize, quillController: quillController,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 43),
                                child: Container(
                                  width: 450,
                                  height: 600,
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    color: CustomTheme.art1,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: ()=> debugPrint(jsonEncode(quillController.document.toDelta().toJson())),
                          style: TextButton.styleFrom(
                              backgroundColor: CustomTheme.buttonSecondary
                          ),
                          child: Center(
                            child: Text(
                                "ZALOGUJ",
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
