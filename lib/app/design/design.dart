import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
// brightness: Brightness.dark,
primaryColor: Color.fromRGBO(0, 201, 178, 1),
buttonColor: Color.fromRGBO(93, 199, 204, 1),
bottomAppBarColor: Colors.grey[850],

textTheme: TextTheme(
headline1: TextStyle(fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily, fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
headline2: TextStyle(fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily, fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
headline4: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
bodyText1: TextStyle(fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily, fontSize: 20, color: Colors.black),
bodyText2: TextStyle(fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily, fontSize: 20, color: Colors.red),
headline3: TextStyle(fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily, fontSize: 20, color: Colors.black),
subtitle1: TextStyle(fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily, fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
subtitle2: TextStyle(fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily, fontSize: 16, color: Colors.black),
headline5: TextStyle(fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily, fontSize: 16, color: Colors.grey),
headline6: TextStyle(fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily, fontSize: 16, color: Colors.red)
)

);