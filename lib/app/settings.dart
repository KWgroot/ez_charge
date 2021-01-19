import 'package:ez_charge/app/design/btn.dart';
import 'package:ez_charge/base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../app/global_variables.dart' as globals;

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
    double btnWidth = MediaQuery.of(context).size.width / 1.5;
    return Scaffold(
        appBar: new AppBar(
          title: Text('Settings', style: Theme.of(context).textTheme.bodyText1),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Theme.of(context).primaryColor,
                      Theme.of(context).buttonColor
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
                auth.sendPasswordResetEmail(email: globals.user.email);
                Fluttertoast.showToast(
                    msg: "We have sent you a password reset email",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              text: 'Change Password',
              color: Theme.of(context).buttonColor,
              tStyle: Theme.of(context).textTheme.bodyText1),
          SwitchListTile(
              title: Text(
                "Inloggen met vingerafdruk of gezicht",
                style: Theme.of(context).textTheme.subtitle1,
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
              color: Theme.of(context).buttonColor,
              tStyle: Theme.of(context).textTheme.bodyText1)
        ]))));
  }

  void logOut(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out', style:  Theme.of(context).textTheme.headline4,),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to log out?', style: Theme.of(context).textTheme.bodyText1,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No', style: Theme.of(context).textTheme.bodyText1,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes', style: Theme.of(context).textTheme.bodyText1,),
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
                    "heeft deze app eenmalig toestemming nodig.", style: Theme.of(context).textTheme.bodyText1,),
            actions: [
              TextButton(
                child: Text("Afwijzen", style: Theme.of(context).textTheme.bodyText1,),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Akkoord", style: Theme.of(context).textTheme.bodyText1,),
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
