import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
                child: Column(
                    children: <Widget>[
                      Text('Settings',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                          textAlign: TextAlign.center),
                    ]
                )
            )
        )
    );
  }
}