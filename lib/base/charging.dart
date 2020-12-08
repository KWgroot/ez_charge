import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../app/global_variables.dart' as globals;
import 'dart:async';
import 'app_page.dart';
import '../app/push_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Charging extends StatefulWidget {
  String docRef;
  Charging({this.docRef});

  @override
  _ChargingState createState() => _ChargingState(docRef);
}


class _ChargingState extends State<Charging> {
  String docRef;
  _ChargingState(this.docRef);


  void initState(){
    _startTimer();
}

  // static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  stopSession(docRef, context) {
    Widget stopSessionBtn = FlatButton(
      child: Text("Stop Session"),
      onPressed: () async {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        firestore.collection("chargingSession").doc(docRef).update({
          "stopTime": DateTime.now(),
        });
        //server sided function (see firebase cloud functions)
        // set up POST request arguments
        Map<String, String> headers = {"Content-type": "application/json"};

        http.get('https://us-central1-ezcharge-22de2.cloudfunctions.net/sendMail?id=' + globals.user.uid.toString());
        Fluttertoast.showToast(
            msg: "Your session has stopped",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage()));
      },
    );
    //
    Widget continueBtn = FlatButton(
      child: Text("Continue Charging"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    //
    AlertDialog alert = AlertDialog(
      title: Text("Weet je zeker dat je de laadsessie wilt stoppen"),
      content: Text(
          "Als je de sessie stopt worden alle kosten die je tot nu toe hebt gemaakt in rekening gebracht"),
      actions: [continueBtn, stopSessionBtn],
    );
    //
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  int _counter = 10;
  Timer _timer;

  void _startTimer() {
    _counter = 10;
if(_timer != null){
  _timer.cancel();
}
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter --;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final pushNotificationService = PushNotificationService(_firebaseMessaging);
    // pushNotificationService.initialise();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (_counter > 0)
                ? Text("")
                : Text(
                    "Auto is volledig geladen!",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
            Text(
              '$_counter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            RaisedButton(
              color: Colors.yellow[400],
              onPressed: () {
                stopSession(docRef, context);
              },
              child: Text("STOP CHARGING"),
            ),
          ],
        ),
      ),
    );
  }
}
