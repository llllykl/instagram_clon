import 'package:flutter/material.dart';

var theme = ThemeData(
  iconTheme: const IconThemeData(
    color: Colors.black,
    size: 60,
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    actionsIconTheme: IconThemeData(color: Colors.black, size: 33),
    titleTextStyle: TextStyle(color: Colors.black),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(backgroundColor: Colors.grey)),
  iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: Colors.black, iconSize: 40)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white, selectedItemColor: Colors.black),
);
