import 'dart:async';

import 'package:ez_charge/base/base.dart';
import 'package:ez_charge/instant_app/app_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'EzCharge',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget with WidgetsBindingObserver {


  @override
  State<StatefulWidget> createState() {
    return _InstantApp();
  }
}

class _InstantApp extends State<MyApp> {
  final formKey = GlobalKey<FormState>();
  var poleId = "";

  @override
  Widget build(BuildContext context) {
    if(poleId == "") {
      handleDynamicLinks(context);
      poleId = getChargingStation();
      Timer(Duration(seconds: 3), () {setState(() {});});
    }
    return MaterialApp(
      title: 'EZCharge',
      home: Scaffold(
        appBar: AppBar(
          title: Text('EZCharge '),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 50.0,),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight,
            key: formKey,
            child: Column(
              children: <Widget>[
                Text('Charge your car',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                    textAlign: TextAlign.center),
                Spacer(),
                Text('If you push the button below you are paying for a charging session on pole: ' + poleId),
                ButtonTheme(child: buttonBottom(), minWidth: double.infinity,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class buttonBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
            color: Colors.yellow[400],
            child: Text(
              'Google Pay',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () =>
            {
              Fluttertoast.showToast(msg: "You simulated that you have payed"),
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AppPage()))
            }
        )
    );
  }
}