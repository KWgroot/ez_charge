import 'package:flutter/material.dart';

final theme = ThemeData(
// brightness: Brightness.dark,
primaryColor: Color.fromRGBO(0, 201, 178, 1),
buttonColor: Color.fromRGBO(93, 199, 204, 1),
backgroundColor: Colors.white70,
bottomAppBarColor: Colors.grey[850],


fontFamily: "open Sans",

textTheme: TextTheme(
headline1: TextStyle(fontFamily: 'open Sans', fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
headline2: TextStyle(fontFamily: 'open Sans', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
bodyText1: TextStyle(fontFamily: 'open Sans', fontSize: 20, color: Colors.black),
bodyText2: TextStyle(fontFamily: 'open Sans', fontSize: 20, color: Colors.red),
subtitle1: TextStyle(fontFamily: 'open Sans', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
subtitle2: TextStyle(fontFamily: 'open Sans', fontSize: 16, color: Colors.black),
headline6: TextStyle(fontFamily: 'open Sans', fontSize: 16, color: Colors.red)
)

);