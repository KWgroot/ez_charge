import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
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