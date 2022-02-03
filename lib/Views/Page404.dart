import 'package:flutter/material.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Utilities.dart';

class Page404 extends StatelessWidget {
  final String test;
  const Page404(this.test, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaSize = Utilities.getDimensions(context);
    return Scaffold(
      backgroundColor: CustomTheme.background,
      body: Center(
        child: Text('Page not found: ' + test),
      ),
    );
  }
}
