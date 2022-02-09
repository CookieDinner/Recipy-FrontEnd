
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipy/Utilities/CustomTheme.dart';

class NavigationButtons extends StatefulWidget {
  const NavigationButtons({required this.currentPage, required this.listLength, required this.amountPerPage, required this.getPage, Key? key}) : super(key: key);
  final int listLength;
  final int amountPerPage;
  final Function getPage;
  final int currentPage;

  @override
  _NavigationButtonsState createState() => _NavigationButtonsState();
}

class _NavigationButtonsState extends State<NavigationButtons> {
  StreamController buttonsStreamController = StreamController<bool>();
  late int currentPage;
  late int numberOfPages;
  List<int> possiblePages = [];
  bool showLeftArrows = false;
  bool showRightArrows = false;

  void calculateButtons() {
    possiblePages.clear();
    numberOfPages = (widget.listLength / widget.amountPerPage).ceil();
    for (int i = 1; i <= numberOfPages; i++) {
      possiblePages.add(i);
    }
    if (currentPage < numberOfPages) {
      showRightArrows = true;
    }
    if (currentPage > 1) {
      showLeftArrows = true;
    }
    buttonsStreamController.add(true);
  }

  void recalculateButtons(int clickedPage) {
    buttonsStreamController.add(false);
    widget.getPage(clickedPage);
    if (clickedPage != currentPage && clickedPage >= 1 && clickedPage <= numberOfPages) {
      currentPage = clickedPage;
      possiblePages.clear();
      if (clickedPage > 1) {
        showLeftArrows = true;
      } else {
        showLeftArrows = false;
      }
      if (clickedPage < numberOfPages) {
        showRightArrows = true;
      } else {
        showRightArrows = false;
      }
      int startingPage = clickedPage - 2;
      if (startingPage < 1) {
        startingPage = 1;
      }
      for (int i = startingPage; i <= numberOfPages - startingPage + 1; i++) {
        if (i > startingPage + 4) {
          break;
        }
        possiblePages.add(i);
      }
      buttonsStreamController.add(true);
    }

  }
  @override
  void initState() {
    currentPage = widget.currentPage;
    calculateButtons();
    super.initState();
  }

  @override
  void dispose() {
    buttonsStreamController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 300,
      child: StreamBuilder(
        stream: buttonsStreamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            if (snapshot.data == false) {
              return Container();
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !showLeftArrows ? Container(width: 64,) : Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        child: ClipOval(
                          child: Material(
                            color: CustomTheme.art1,
                            borderRadius: BorderRadius.circular(50),
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                hoverColor: CustomTheme.art3,
                                highlightColor: CustomTheme.textDark,
                                onPressed: () {
                                  recalculateButtons(1);
                                },
                                icon: Container(
                                  child: Row(
                                    children: [
                                      Container(width: 9,
                                          child: Icon(Icons.keyboard_arrow_left,
                                            color: CustomTheme.textDark,
                                            size: 32,)),
                                      Container(width: 9,
                                          child: Icon(Icons.keyboard_arrow_left,
                                            color: CustomTheme.textDark,
                                            size: 32,)),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        child: ClipOval(
                          child: Material(
                            color: CustomTheme.art1,
                            borderRadius: BorderRadius.circular(50),
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                hoverColor: CustomTheme.art3,
                                highlightColor: CustomTheme.textDark,
                                onPressed: () {
                                  recalculateButtons(currentPage - 1);
                                },
                                icon: Icon(Icons.keyboard_arrow_left,
                                  color: CustomTheme.textDark, size: 32,)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: (32 * numberOfPages).toDouble(),
                    height: 32,
                    child: ListView.builder(
                        itemCount: numberOfPages,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 32,
                            height: 32,
                            child: ClipOval(
                              child: Material(
                                color: currentPage == possiblePages[index]
                                    ? CustomTheme.iconSelectedFill
                                    : CustomTheme.art1,
                                borderRadius: BorderRadius.circular(50),
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    hoverColor: currentPage ==
                                        possiblePages[index] ? CustomTheme
                                        .iconSelectedFill : CustomTheme.art3,
                                    highlightColor: CustomTheme.textDark,
                                    onPressed: () {
                                      recalculateButtons(possiblePages[index]);
                                    },
                                    icon: Container(
                                      child: Text(
                                          possiblePages[index].toString(),
                                          style: TextStyle(
                                              color: CustomTheme.textDark,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18)),
                                    )
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                  !showRightArrows ? Container(width: 64,) : Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        child: ClipOval(
                          child: Material(
                            color: CustomTheme.art1,
                            borderRadius: BorderRadius.circular(50),
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                hoverColor: CustomTheme.art3,
                                highlightColor: CustomTheme.textDark,
                                onPressed: () {
                                  recalculateButtons(currentPage + 1);
                                },
                                icon: Icon(Icons.keyboard_arrow_right,
                                  color: CustomTheme.textDark, size: 32,)
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        child: ClipOval(
                          child: Material(
                            color: CustomTheme.art1,
                            borderRadius: BorderRadius.circular(50),
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                hoverColor: CustomTheme.art3,
                                highlightColor: CustomTheme.textDark,
                                onPressed: () {
                                  recalculateButtons(numberOfPages);
                                },
                                icon: Container(
                                  child: Row(
                                    children: [
                                      Container(width: 0,
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: CustomTheme.textDark,
                                            size: 32,)),
                                      const SizedBox(width: 8,),
                                      Container(width: 0,
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: CustomTheme.textDark,
                                            size: 32,)),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          }
        }
      ),
    );
  }
}
