
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipy/CustomWidgets/Editor.dart';
import 'package:recipy/CustomWidgets/Footer.dart';
import 'package:recipy/CustomWidgets/ImageGallery.dart';
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
  int? userId;
  late quill.QuillController quillController;
  
  Future<void> getArticle() async {
    String response = await Requests.getArticle(widget.articleId);
    article = Article.fromDetailed(jsonDecode(response));
    quillController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(article.content)),
      selection: const TextSelection.collapsed(offset: 0)
    );
    for (Uint8List image in article.resources) {
      images.add(image);
    }
    articleStreamController.add(true);
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await getArticle();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString("accessToken");
      userId = prefs.getInt("userId");
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
                        height: 2000,
                        width: mediaSize.width,
                        child: StreamBuilder(
                          stream: articleStreamController.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: mediaSize.height * 0.3,),
                                    Text("Trwa pobieranie artykułu...",
                                      style: Constants.textStyle(
                                          textStyle: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: CustomTheme.text,
                                              height: 2
                                          )
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 400,
                                      width: 400,
                                      child: Center(
                                        child: SpinKitFadingCircle(
                                          size: 120,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(110, 110, 110, 0),
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
                                      width: mediaSize.width,
                                      color: CustomTheme.secondaryBackground,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(40, 50, 40, 0),
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
                                                      article.isPublished! ? SizedBox(
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
                                                      ) : Container(),
                                                      accessToken != null && userId != null && userId != article.author_id ? SizedBox(
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
                                                                      color: CustomTheme.buttonSecondary.withOpacity(0.75)
                                                                  );
                                                                },
                                                                onRatingUpdate: (rating) async {
                                                                  String response = await Requests.rateArticle(article, rating);
                                                                    setState(() {
                                                                      article.userRating = rating;
                                                                      article.rating = jsonDecode(response)["new_rate"];
                                                                    });
                                                                },
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
                                                            Text("( " + article.userRating.toStringAsFixed(2) + " )", style: Constants.textStyle(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
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
                                      width: mediaSize.width,
                                      color: CustomTheme.secondaryBackground,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Galeria zdjęć",
                                              style: Constants.textStyle(
                                                  textStyle: TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w500,
                                                    color: CustomTheme.textDark,
                                                  )
                                              )
                                          ),
                                          SizedBox(height: 40,),
                                          ImageGallery(imageStreamController: StreamController(), images: images, canDelete: false,),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: CustomTheme.secondaryBackground,
                                      ),
                                    ),
                                    Footer(),
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
