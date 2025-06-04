import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade500),
  primaryColor: Colors.grey.shade500,
  scaffoldBackgroundColor: Colors.grey.shade300,
  hintColor: Colors.grey.shade200,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.grey,
  ).copyWith(
    secondary: Colors.grey[400],
  ),
);
