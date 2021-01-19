import 'package:flutter/material.dart';
import 'design.dart';

class Button extends StatelessWidget {

  final String text;
  final Function onPressed;
  final Color color;
  final TextStyle tStyle;

  Button({ @required this.onPressed, @required this.text, @required this.color,@required this.tStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0,left: 10.0),
      child:ButtonTheme(
        minWidth: double.infinity,
        height: 40.0,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            color: color,
            child: Text(
                text,
                style: tStyle
            ),
            onPressed: onPressed
        )
    ),
    );
  }
}