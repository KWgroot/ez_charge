import 'package:ez_charge/app/main.dart';
import 'package:ez_charge/base/base.dart';
import 'package:ez_charge/base/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../app/global_variables.dart' as globals;
import 'package:firebase_core/firebase_core.dart';

class Settings extends StatefulWidget {
  @override
  SettingsScreen createState() => SettingsScreen();
}

class SettingsScreen extends State<Settings> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var _data;

  // @override
  // void initState() {
  //   print(ModalRoute.of(context).settings.name);
  // }

  Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (BuildContext context) {
          //some custom code
          return _data[settings.name](context);
        },
        settings: settings
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
                child: Column(children: <Widget>[
                  SizedBox(height: 20),
                  Text('Settings',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                      textAlign: TextAlign.center),
                  RaisedButton(
                      color: Colors.yellow[400],
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        'Change Password',
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      onPressed: () async {
                        auth.sendPasswordResetEmail(email: globals.user.email);
                        Fluttertoast.showToast(
                            msg: "We have sent you a password reset email",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }),
                  SwitchListTile(
                    title: Text("Vingerafdrukscanner"),
                      value: globals.enabledFingerprint,
                      onChanged: (value){
                    setState(() {
                      setFingerPrintEnabled(value);
                    });
                  }),
                  ButtonTheme(
                      minWidth: double.infinity,
                      height: 40.0,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.yellow[400],
                          child: Text('Log out',
                              style: TextStyle(color: Colors.black, fontSize: 20.0)),
                          onPressed: () async {
                            logOut(context);
                          })
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/');
                // print(_data);
                },
            ),
          ],
        );
      },
    );
  }
}
