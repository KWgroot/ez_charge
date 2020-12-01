import 'package:ez_charge/app/main.dart';
import 'package:ez_charge/base/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Settings extends StatelessWidget{
  FirebaseAuth auth = FirebaseAuth.instance;
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
                      ButtonTheme(
                          minWidth: double.infinity,
                          height: 40.0,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              color: Colors.yellow[400],
                              child: Text(
                                  'Log out',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0
                                  )
                              ),
                              onPressed: () async {logOut(context);}
                          )
                      ),
                    ]
                )
            )
        )
    );
  }
  void logOut(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                await auth.signOut();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                },
            ),
          ],
        );
      },
    );
  }
}