import 'package:flutter/material.dart';

const lprimaryColor =Color.fromRGBO(78,27,217,1) ;
const lsecondaryColor = Color.fromRGBO(175,255,182,1);

const dprimaryColor =Color.fromARGB(255, 9, 9, 9) ;
const dsecondaryColor = Colors.white10;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: lprimaryColor,
  secondaryHeaderColor: lprimaryColor,
  focusColor: lsecondaryColor,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: lprimaryColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      backgroundColor: WidgetStateProperty.all(lprimaryColor)
    )
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
    headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: lprimaryColor),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: lprimaryColor),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
    titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: lprimaryColor),
    bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: lprimaryColor),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: lprimaryColor),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: lprimaryColor),
    // Added missing styles
  )
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  focusColor: dsecondaryColor,
  secondaryHeaderColor: lsecondaryColor,
  primaryColor: dprimaryColor,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: dprimaryColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      backgroundColor: WidgetStateProperty.all(dsecondaryColor),
      alignment: Alignment.center,
    )
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: lprimaryColor),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: lprimaryColor),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: lprimaryColor),
    headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: lsecondaryColor),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: dprimaryColor),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: lprimaryColor),
    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: lprimaryColor),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
    titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: lprimaryColor),
    bodyLarge: TextStyle(fontSize: 16, color: lprimaryColor),
    bodyMedium: TextStyle(fontSize: 14, color: lsecondaryColor),
    bodySmall: TextStyle(fontSize: 12, color: lprimaryColor),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: lsecondaryColor),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: dsecondaryColor),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white30)
  )
);