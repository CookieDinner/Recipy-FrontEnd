
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipy/CustomWidgets/Editor.dart';
import 'package:recipy/CustomWidgets/RecipeViewer.dart';
import 'package:recipy/CustomWidgets/Waves.dart';
import 'package:recipy/CustomWidgets/rNavBar.dart';
import 'package:recipy/Entities/Article.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';
import 'package:recipy/Utilities/Utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class ArticleView extends StatefulWidget {
  final int articleId;
  const ArticleView(this.articleId, {Key? key}) : super(key: key);

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  ScrollController scrollController = ScrollController();
  List<Uint8List> images = [];
  List<double> nutrition = [0, 0, 0, 0];
  final articleStreamController = StreamController<bool>();
  late Article article;
  String? accessToken;
  late double userRating;
  late quill.QuillController quillController;
  
  Future<void> getArticle() async {
    String response = await Requests.getArticle(widget.articleId);
    article = Article.fromDetailed(jsonDecode(response));
    quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(article.content)),
      selection: const TextSelection.collapsed(offset: 0)
    );
    articleStreamController.add(true);
    userRating = article.userRating;
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await getArticle();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString("accessToken");
    });
    super.initState();
  }
  
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
                      child: SizedBox(
                        height: 1700,
                        width: mediaSize.width,
                        child: StreamBuilder(
                          stream: articleStreamController.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: SizedBox(
                                  height: 42,
                                  width: 60,
                                  child: Center(
                                    child: SpinKitFadingCircle(
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(110.0),
                                      //Top page title
                                      child: SizedBox(
                                          child: Text(article.title,
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
                                    Container(
                                      width: mediaSize.width,
                                      color: CustomTheme.secondaryBackground,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 170,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("Autor: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                                                          Text(article.author, style: Constants.textStyle(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("Data: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                                                          Text(article.date, style: Constants.textStyle(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 335,
                                                        child: Row(
                                                          children: [
                                                            Text("Ocena: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                                                            accessToken != null ? Spacer() : Container(),
                                                            SizedBox(width: 10,),
                                                            RatingBarIndicator(
                                                              rating: article.rating,
                                                              itemBuilder: (context, _){
                                                                return FaIcon(
                                                                    FontAwesomeIcons.breadSlice,
                                                                    color: CustomTheme.textDark.withOpacity(0.8)
                                                                );
                                                              },
                                                              itemCount: 5,
                                                              itemSize: 24,
                                                              itemPadding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                                              unratedColor: CustomTheme.art2,
                                                            ),
                                                            SizedBox(width: 10,),
                                                            Text("( " + article.rating.toStringAsFixed(2) + " )", style: Constants.textStyle(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                                                          ],
                                                        ),
                                                      ),
                                                      accessToken != null ? SizedBox(
                                                        width: 335,
                                                        height: 28,
                                                        child: Row(
                                                          children: [
                                                            Text("Twoja Ocena: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                                                            Spacer(),
                                                            SizedBox(width: 10,),
                                                            MouseRegion(
                                                              cursor: SystemMouseCursors.click,
                                                              child: RatingBar.builder(
                                                                initialRating: article.userRating,
                                                                itemBuilder: (context, _){
                                                                  return FaIcon(
                                                                      FontAwesomeIcons.breadSlice,
                                                                      color: CustomTheme.textDark.withOpacity(0.8)
                                                                  );
                                                                },
                                                                onRatingUpdate: (rating) => setState(() {
                                                                  userRating = rating;
                                                                }),
                                                                allowHalfRating: false,
                                                                minRating: 1.0,
                                                                maxRating: 5.0,
                                                                itemCount: 5,
                                                                itemSize: 24,
                                                                itemPadding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                                                unratedColor: CustomTheme.art2,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            Text("( " + userRating.toStringAsFixed(2) + " )", style: Constants.textStyle(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                                                          ],
                                                        ),
                                                      ) : SizedBox(height: 28,),
                                                    ],
                                                  ),
                                                ),
                                                Editor(mediaSize, quillController: quillController, readOnly: true,)
                                              ],
                                            ),
                                            RecipeViewer(article.recipe)
                                          ],
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
                                  ]
                              );
                            }
                          }
                      ),
                    )
                )
              )
            ),
          ]),
          rNavBar(),
        ],
      ),
    );
  }
}
