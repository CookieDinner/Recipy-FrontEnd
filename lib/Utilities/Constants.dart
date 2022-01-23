import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static const int timeoutTime = 10;
  static const String loginAPI =  "https://recipython.herokuapp.com/login";
  static const String userAPI =  "https://recipython.herokuapp.com/user";
  static TextStyle textStyle({TextStyle? textStyle}){
    return GoogleFonts.ptSans(textStyle: textStyle);
  }
}