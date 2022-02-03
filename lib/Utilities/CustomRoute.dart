import 'package:flutter/material.dart';

class CustomRoute extends PageRouteBuilder{
  CustomRoute(Widget widget) : super(pageBuilder: (_,__,___) => widget,
      transitionDuration: const Duration(seconds: 0));
}