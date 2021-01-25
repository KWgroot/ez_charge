import 'package:ez_charge/app/design/btn.dart';
import 'package:ez_charge/app/design/design.dart';
import 'package:ez_charge/base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import '../app/global_variables.dart' as globals;
import 'change_credentials.dart';

class Settings extends StatefulWidget {
  @override
  SettingsScreen createState() => SettingsScreen();
}

class SettingsScreen extends State<Settings> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();
  bool _canCheckBiometric = false;
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
    _checkBiometric();
    _getListOfBiometricTypes();

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
              value: globals.isBiometricEnabled,
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
          title: Text('Log out', style:  theme.textTheme.headline4,),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to log out?', style: theme.textTheme.subtitle2,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No', style: theme.textTheme.headline3,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes', style: theme.textTheme.headline3,),
              onPressed: () async {
                if(!globals.isBiometricEnabled){
                  await auth.signOut();
                }
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
  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;

    try{
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();

    } on PlatformException catch (error){
      print(error);
    }

    if(!mounted){
      return;
    }

    setState(() {
      _availableBiometricTypes = listOfBiometrics;
    });
  }
  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try{
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (error){
      print(error);
    }

    if(!mounted){
      return;
    }

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }
  void confirmBiometric(context, enableBiometric) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Toestemming vereist", style: theme.textTheme.headline4,),
            content:
                Text("Om in te kunnen loggen met je vingerafdruk of gezicht, "
                    "heeft deze app eenmalig toestemming nodig.", style: theme.textTheme.subtitle2,),
            actions: [
              TextButton(
                child: Text("Afwijzen", style: theme.textTheme.headline3,),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Akkoord", style: theme.textTheme.headline3,),
                onPressed: () async {
                  setState(() {
                    if(_canCheckBiometric){
                      setEnableBiometric(enableBiometric);
                      setPermission(false);
                    }else{
                      Fluttertoast.showToast(msg: "Uw toestel beschikt niet over een vingerafdrukscanner of camera", toastLength: Toast.LENGTH_SHORT);
                    }

                  });

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
