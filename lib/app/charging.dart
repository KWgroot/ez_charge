import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Charging extends StatelessWidget {
  String docRef;
  Charging({this.docRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          color: Colors.yellow[400],
          onPressed: () {
            stopSession(docRef, context);
          },
          child: Text(
            'STOP CHARGING',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  stopSession(docRef, context) {
    Widget stopSessionBtn = FlatButton(
      child: Text("Stop Session"),
      onPressed: () {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        firestore.collection("chargingSession").doc(docRef).update({
          "stopTime": DateTime.now(),
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Your session has stopped",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
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
}