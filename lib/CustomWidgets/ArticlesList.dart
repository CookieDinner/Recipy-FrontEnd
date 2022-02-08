
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipy/Entities/Article.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomRoute.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Views/ArticleView.dart';

class ArticlesList extends StatefulWidget {
  final Size mediaSize;
  final List<Article> articles;
  const ArticlesList(this.mediaSize, this.articles, {Key? key}) : super(key: key);

  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.mediaSize.width * 0.38,
      width: widget.mediaSize.width * 0.50,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 160
          ),
          itemCount: widget.articles.length,
          itemBuilder: (context, index) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(CustomRoute(ArticleView(widget.articles[index].id))),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  color: CustomTheme.art5,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: widget.mediaSize.width * 0.03,
                            child: Text(widget.articles[index].title, style: Constants.textStyle(textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Ocena: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                                      RatingBarIndicator(
                                        rating: widget.articles[index].rating,
                                        itemBuilder: (context, _){
                                          return FaIcon(
                                              FontAwesomeIcons.breadSlice,
                                              color: CustomTheme.textDark.withOpacity(0.8)
                                          );
                                        },
                                        itemCount: 5,
                                        itemSize: 12,
                                        itemPadding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                        unratedColor: CustomTheme.art2,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Autor: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                                      Text(widget.articles[index].author, style: Constants.textStyle(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Data: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                                      Text(widget.articles[index].date, style: Constants.textStyle(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: widget.mediaSize.width * 0.025,
                                width: widget.mediaSize.width * 0.08,
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
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
                                          width: widget.mediaSize.width * 0.055,
                                          child: Text(widget.articles[index].recipe.title, style: Constants.textStyle(textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: CustomTheme.textDark)), overflow: TextOverflow.fade,),
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.utensils,
                                          color: CustomTheme.textDark.withOpacity(0.7),
                                          size: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
