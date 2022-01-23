import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';

class RecommendedArticles extends StatefulWidget {
  final Size mediaSize;
  const RecommendedArticles(this.mediaSize, {Key? key}) : super(key: key);

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
              itemCount: 5,
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
                              Text("Data: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                              Text("null", style: Constants.textStyle(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Text("Autor: ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                              Text("null", style: Constants.textStyle(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text("Jak poznałem buraki ", style: Constants.textStyle(textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CustomTheme.textDark)),),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 200,
                            width: 450,
                            child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                                "Mauris vitae mi efficitur, accumsan tortor sit amet, semper justo. "
                                "Vivamus dignissim elit at posuere vulputate. "
                                "Pellentesque euismod et neque a ornare. "
                                "Maecenas ultrices odio vitae metus laoreet, ut pharetra neque congue. [...]",
                              style: Constants.textStyle(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w200, color: CustomTheme.textDark)),),
                          ),
                        ],
                      ),
                      Container(),
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
                                child: Center(child: Text("Buraki na twardo", style: Constants.textStyle(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomTheme.textDark)),)),
                              ),
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: Center(
                                  child: Text(
                                      "Zaloguj się, \naby zapisać przepis",
                                      textAlign: TextAlign.center,
                                      style: Constants.textStyle(
                                          textStyle: TextStyle(
                                              overflow: TextOverflow.clip,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: CustomTheme.textDark
                                          )
                                      )
                                  ),
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
                  dotsCount: 5,
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
