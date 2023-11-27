import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color blackColor = Colors.black;
Color whiteColor = Colors.white;

class userThemes {
  static final darkTheme = ThemeData(
    fontFamily: 'Outfit',
    textTheme: TextTheme(
      button: TextStyle(
        color: Colors.white
      ),
      bodyText1: TextStyle(
        color: whiteColor
      ),
    ),
    primaryIconTheme: IconThemeData(
      color: whiteColor
    ),
    scaffoldBackgroundColor: blackColor,
    cardColor: blackColor,
    colorScheme: ColorScheme.dark(primary: Colors.white, secondary: Color.fromARGB(255, 19, 19, 19)),
    primaryColor: Colors.black,
    iconTheme: IconThemeData(
      color: whiteColor,
      size: 25,
      ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:Colors.transparent, // <-- SEE HERE
          statusBarIconBrightness: Brightness.light, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.dark, //<-- For iOS SEE HERE (dark icons)
        ),
      color: blackColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Color.fromARGB(255, 35, 35, 35),
        foregroundColor: Colors.white,
        
      )
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: whiteColor,
      backgroundColor: Color.fromARGB(255, 255, 0, 30),
    ),
    
    );

  static final lightTheme = ThemeData(
    fontFamily: 'Outfit',
    scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
    cardColor: whiteColor,
    colorScheme: const ColorScheme.light(primary: Colors.black, secondary: Color.fromARGB(255, 235, 235, 235)),
    primaryColor: Colors.white,
    iconTheme: IconThemeData(
      color: blackColor,
      size: 25
      ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:Colors.transparent, // <-- SEE HERE
          statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: Colors.white,
      // ),
      color: whiteColor,
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Color.fromARGB(255, 235, 235, 235),
        foregroundColor: blackColor
      )
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: whiteColor,
      backgroundColor: Color.fromARGB(255, 255, 0, 30),
    ),
    
    
  );
}

