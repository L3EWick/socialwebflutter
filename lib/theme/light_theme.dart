import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20)),
    colorScheme: ColorScheme.light(
      background: Colors.grey[350]!,
      primary: Colors.grey[200]!,
      secondary: Colors.grey[300]!,
    ));
