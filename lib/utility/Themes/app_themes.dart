import 'package:flutter/material.dart';

final appThemeData = {
  'PurpleLight': ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.purple,
    buttonColor: Colors.purpleAccent,
    errorColor: Colors.red,
    bottomAppBarColor: Colors.white,
  ),
  'DarkNormal': ThemeData.dark(),
  'PurpleDark': ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF1C1C27),
    cardColor: Color(0xFF28293D),
//    buttonColor: Color(0xFF2B2B3B),
    buttonColor: Color(0xFFBB86FC),
    highlightColor: Color(0xFFBB86FC).withAlpha(30),
    accentColor: Color(0xFFBB86FC),
    indicatorColor: Color(0xFFBB86FC),
    canvasColor: Color(0xFF28293D),
    backgroundColor: Color(0xFFC1C1D7),
    scaffoldBackgroundColor: Color(0xFF28283E),
    bottomAppBarColor: Color(0xFF28293D),
    errorColor: Colors.pinkAccent,
    dialogBackgroundColor: Color(0xFF28293D),
  ),
};
