import 'dart:io';

import 'package:flutter/material.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';
import 'package:recipy/Views/AddArticle.dart';
import 'package:recipy/Views/Home.dart';
import 'package:recipy/Views/Page404.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:intl/intl.dart';

void main() async{
  setPathUrlStrategy();
  runApp(const RecipyApp());
}

class RecipyApp extends StatelessWidget{
  const RecipyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      navigatorObservers: [NavigationHistoryObserver()],
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomTheme.art3
            )
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: CustomTheme.textDark
              )
          ),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.redAccent
              )
          ),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.redAccent
              )
          ),
        )
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('pl')
      ],
    );
  }

}
class NoAnimationRoute<T> extends MaterialPageRoute<T> {
  NoAnimationRoute({required WidgetBuilder builder})
      : super(builder: builder, maintainState: true, fullscreenDialog: false);
  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}