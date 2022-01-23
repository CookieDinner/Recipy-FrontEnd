import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static const int timeoutTime = 10;
  static const String apiRoot = "https://recipython.herokuapp.com";
  static const String loginAPI =  "$apiRoot/login";
  static const String userAPI =  "$apiRoot/user/0";
  static const String myDataAPI =  "$apiRoot/me";
  static TextStyle textStyle({TextStyle? textStyle}){
    return GoogleFonts.ptSans(textStyle: textStyle);
  }
}