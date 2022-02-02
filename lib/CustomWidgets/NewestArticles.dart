import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipy/Entities/Article.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Utilities.dart';

class NewestArticles extends StatefulWidget {
  final Size mediaSize;
  final List<Article> articles;
  const NewestArticles(this.mediaSize, this.articles, {Key? key}) : super(key: key);

  @override
  _NewestArticlesState createState() => _NewestArticlesState();
}

class _NewestArticlesState extends State<NewestArticles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.mediaSize.width * 0.42,
      width: widget.mediaSize.width * 0.55,
      color: CustomTheme.newestArticlesBackground,
      child: ListView.builder(
        itemCount: widget.articles.length,
        padding: EdgeInsets.symmetric(horizontal: widget.mediaSize.width * 0.04, vertical: widget.mediaSize.width * 0.02),
        itemBuilder: (context, index){
          return Padding(
            padding: EdgeInsets.symmetric(vertical: widget.mediaSize.width * 0.007),
            child: Container(
              height: widget.mediaSize.width * 0.04,
              color: CustomTheme.singleNewArticleBackgrond,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.articles[index].title, style: Constants.textStyle(textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                        Row(
                          children: [
                            Text("Autor: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                            SizedBox(
                              width: 80,
                              child: Text(widget.articles[index].author, style: Constants.textStyle(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                            ),
                            Text("Data: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                            SizedBox(
                              width: 80,
                              child: Text(widget.articles[index].date, style: Constants.textStyle(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                            ),
                            Text("Ocena: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                            RatingBarIndicator(
                              rating: widget.articles[index].rating,
                              itemBuilder: (context, _){
                                return FaIcon(
                                    FontAwesomeIcons.breadSlice,
                                    color: CustomTheme.textDark.withOpacity(0.8)
                                );
                              },
                              itemCount: 5,
                              itemSize: 10,
                              itemPadding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                              unratedColor: CustomTheme.art2,
                            ),
                            Text(" (" + widget.articles[index].rating.toStringAsFixed(2) + ")", style: Constants.textStyle(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: widget.mediaSize.width * 0.025,
                      width: widget.mediaSize.width * 0.18,
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)
                        ),
                        color: CustomTheme.art2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: widget.mediaSize.width * 0.018,
                                width: widget.mediaSize.width * 0.145,
                                child: Text(widget.articles[index].recipe.title, style: Constants.textStyle(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: CustomTheme.textDark))),
                              ),
                              FaIcon(
                                FontAwesomeIcons.utensils,
                                color: CustomTheme.textDark.withOpacity(0.7),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ]
                ),
              )
            ),
          );
        }),
    );
  }
}
