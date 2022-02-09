import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipy/Entities/Article.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomRoute.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Utilities.dart';
import 'package:recipy/Views/ArticleView.dart';

class RecommendedArticles extends StatefulWidget {
  final Size mediaSize;
  final List<Article> articles;
  const RecommendedArticles(this.mediaSize, this.articles, {Key? key}) : super(key: key);

  @override
  _RecommendedArticlesState createState() => _RecommendedArticlesState();
}

class _RecommendedArticlesState extends State<RecommendedArticles> {
  CarouselController carouselController = CarouselController();
  double _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          SizedBox(
            height: widget.mediaSize.width * 0.25,
            width: widget.mediaSize.width * 0.55,
            child: CarouselSlider.builder(
              carouselController: carouselController,
              itemCount: widget.articles.length,
              options: CarouselOptions(
                  initialPage: 0,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 10),
                  onPageChanged: (index, reason){
                    setState(() {
                      _pageIndex = index.toDouble();
                    });
                  }
              ),
              itemBuilder: (BuildContext context, int index, int pageViewIndex){
                String parsedContent = Utilities.decodeEditorText(widget.articles[index].content);
                if (parsedContent.length > 481){
                  parsedContent = parsedContent.substring(0, 480);
                }
                return Container(
                  color: CustomTheme.art1,
                  height: widget.mediaSize.width * 0.25,
                  width: widget.mediaSize.width * 0.55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Autor: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                              Text(widget.articles[index].author, style: Constants.textStyle(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Text("Data: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                              Text(widget.articles[index].date, style: Constants.textStyle(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Text("Ocena: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                              RatingBarIndicator(
                                rating: widget.articles[index].rating,
                                  itemBuilder: (context, _){
                                    return FaIcon(
                                      FontAwesomeIcons.breadSlice,
                                      color: CustomTheme.textDark.withOpacity(0.8)
                                    );
                                  },
                                itemCount: 5,
                                itemSize: 16,
                                itemPadding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                unratedColor: CustomTheme.art2,
                              ),
                              Text(" (" + widget.articles[index].rating.toStringAsFixed(2) + ")", style: Constants.textStyle(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text(widget.articles[index].title, style: Constants.textStyle(textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 200,
                            width: 450,
                            child: Text(parsedContent + " (...)",
                              style: Constants.textStyle(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),),
                          ),
                          SizedBox(
                            width: widget.mediaSize.width * 0.25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: widget.mediaSize.width * 0.06,
                                  child: TextButton(
                                    onPressed: ()=> Navigator.of(context).push(CustomRoute(ArticleView(widget.articles[index].id))),
                                    style: TextButton.styleFrom(
                                        backgroundColor: CustomTheme.iconSelectedFill.withOpacity(0.3)
                                    ),
                                    child: Center(
                                      child: Text(
                                          "Czytaj dalej",
                                          style: Constants.textStyle(
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: CustomTheme.textDark
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 300,
                        width: 250,
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)
                          ),
                          color: CustomTheme.art2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Przepis:", style: Constants.textStyle(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomTheme.textDark))),
                              SizedBox(
                                height: 150,
                                width: 180,
                                child: Center(child: Text(widget.articles[index].recipe.title, style: Constants.textStyle(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.textDark)),textAlign: TextAlign.center,)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(165, 40, 0, 0),
                                child: FaIcon(
                                  FontAwesomeIcons.utensils,
                                  color: CustomTheme.textDark.withOpacity(0.7),
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: widget.mediaSize.width * 0.25,
            width: widget.mediaSize.width * 0.55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 75,
                  width: 75,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => carouselController.previousPage(
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.decelerate
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.fromLTRB(23, 0, 0, 0),
                        child: Icon(Icons.arrow_back_ios, color: CustomTheme.art3, size: 60,),
                      )
                  ),
                ),
                SizedBox(
                  height: 75,
                  width: 75,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => carouselController.nextPage(
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.decelerate
                      ),
                      icon: Icon(Icons.arrow_forward_ios, color: CustomTheme.art3, size: 60,)
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.mediaSize.width * 0.25,
            width: widget.mediaSize.width * 0.55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DotsIndicator(
                  dotsCount: widget.articles.length,
                  position: _pageIndex,
                  decorator: DotsDecorator(
                    color: CustomTheme.secondaryBackground,
                    activeColor: CustomTheme.text
                  ),
                ),
                SizedBox(height: 15,)
              ],
            )
          )
        ],
      ),
    );
  }
}
