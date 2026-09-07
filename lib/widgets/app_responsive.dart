import 'package:flutter/widgets.dart';

class AppResponsive {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
  }

  static double h(double percent) => screenHeight * (percent / 100);

  static double w(double percent) => screenWidth * (percent / 100);
}