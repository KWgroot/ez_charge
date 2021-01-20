import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
    primaryColor: Color.fromRGBO(0, 201, 178, 1),
    buttonColor: Color.fromRGBO(93, 199, 204, 1),
    backgroundColor: Color.fromRGBO(235, 235, 235, 1),
    bottomAppBarColor: Colors.grey[850],
    textTheme: TextTheme(
      /// Title
        headline1: TextStyle(
            fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black),
        /// Subtitle
        headline2: TextStyle(
            fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black),
        /// Button AlertDialog
        headline3: TextStyle(
            fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w100,
            color: Colors.blueAccent),
        /// Title AlertDialog
      headline4: TextStyle(
          fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black),
        /// Location Card subtext
        headline5: TextStyle(
            fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
            fontSize: 16,
            color: Colors.grey),
        //Todo
        headline6: TextStyle(
            fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
            fontSize: 16,
            color: Colors.red),
        /// Standaard tekst
        bodyText1: TextStyle(
            fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w100,
            color: Colors.black),
        /// Standard Error Message
        bodyText2: TextStyle(
            fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
            fontSize: 20,
            color: Colors.red),
        /// Homepage Table
        subtitle1: TextStyle(
            fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black),
        /// Text AlertDialog + Hints UserInput
        subtitle2: TextStyle(
            fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w100,
            color: Colors.black),
        ));
