import 'package:ez_charge/app/design/btn.dart';
import 'package:ez_charge/app/design/design.dart';
import 'package:ez_charge/base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../app/global_variables.dart' as globals;
import 'change_credentials.dart';

class Settings extends StatefulWidget {
  @override
  SettingsScreen createState() => SettingsScreen();
}

class SettingsScreen extends State<Settings> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var _data;

  Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (BuildContext context) {
          //some custom code
          return _data[settings.name](context);
        },
        settings: settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
        appBar: new AppBar(
          title: Text('Settings', style: theme.textTheme.bodyText1),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      theme.primaryColor,
                      theme.buttonColor
                    ]
                )
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: Form(
                child: Column(children: <Widget>[
          SizedBox(height: 20),
          Button(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeCredentials()));
              },
              text: 'Change Password',
              color: theme.buttonColor,
              tStyle: theme.textTheme.bodyText1),
          SwitchListTile(
              title: Text(
                "Inloggen met vingerafdruk of gezicht",
                style: theme.textTheme.subtitle1,
              ),
              value: globals.enabledBiometric,
              onChanged: (enableBiometric) {
                //Biometrics is never been used before when
                //askForPermissionForFirstTime is true.
                if (globals.askForPermissionForFirstTime == null) {
                  setState(() {
                    //asking for permission
                    confirmBiometric(context, enableBiometric);
                  });
                } else {
                  setState(() {
                    setEnableBiometric(enableBiometric);
                  });
                }
              }),
          Button(
              onPressed: () {
                logOut(context);
              },
              text: 'Log out',
              color: theme.buttonColor,
              tStyle: theme.textTheme.bodyText1)
        ]))));
  }

  void logOut(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out', style:  theme.textTheme.headline4,),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to log out?', style: theme.textTheme.bodyText1,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No', style: theme.textTheme.bodyText1,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes', style: theme.textTheme.bodyText1,),
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

  void confirmBiometric(context, enableBiometric) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Toestemming vereist"),
            content:
                Text("Om in te kunnen loggen met je vingerafdruk of gezicht, "
                    "heeft deze app eenmalig toestemming nodig.", style: theme.textTheme.bodyText1,),
            actions: [
              TextButton(
                child: Text("Afwijzen", style: theme.textTheme.bodyText1,),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Akkoord", style: theme.textTheme.bodyText1,),
                onPressed: () async {
                  setState(() {
                    setEnableBiometric(enableBiometric);
                    setPermission(false);
                  });

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
