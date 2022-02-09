
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:recipy/CustomWidgets/Footer.dart';
import 'package:recipy/CustomWidgets/Waves.dart';
import 'package:recipy/CustomWidgets/rNavBar.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Utilities.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  ScrollController scrollController = ScrollController();
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 110, 0, 0),
                            child: Column(
                              children: [
                                SizedBox(
                                    child: Text("O nas",
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
                                  child: Text("Gdybyśmy mieli co powiedzieć to tutaj byłoby na to miejsce...",
                                    style: Constants.textStyle(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: CustomTheme.text,
                                          height: 2
                                      ),
                                    ), textAlign: TextAlign.center,
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
                                  height: 535,
                                  color: CustomTheme.secondaryBackground,
                                ),
                                Footer()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
          rNavBar(),
        ],
      ),
    );
  }
}
