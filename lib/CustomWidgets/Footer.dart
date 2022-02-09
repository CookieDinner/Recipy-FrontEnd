
import 'package:flutter/material.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card(
        color: CustomTheme.background,
        elevation: 20,
        margin: EdgeInsets.zero,
        child: Center(
          child: Text("© 2022. Reci.py. All Rights Reserved",
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
    );
  }
}
