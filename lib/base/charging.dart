import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_charge/app/design/btn.dart';
import 'package:ez_charge/app/design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../app/app_page.dart';
import 'package:http/http.dart' as http;
import '../app/global_variables.dart' as globals;

class Charging extends StatelessWidget {
  String docRef;
  Charging({this.docRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Button(
          color: theme.buttonColor,
          onPressed: () {
            stopSession(docRef, context);
          },
          text:
            'STOP CHARGING',
            tStyle: theme.textTheme.bodyText1,
          ),
        ),
    );
  }

  stopSession (docRef, context) {
    Widget stopSessionBtn = TButton(
      text: "Stop Session",
      onPressed: () async {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        firestore.collection("chargingSession").doc(docRef).update({
          "stopTime": DateTime.now(),
        });
        //server sided function (see firebase cloud functions)
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
      tStyle: theme.textTheme.headline3,
    );
    //
    Widget continueBtn = TButton(
      text: "Continue Charging",
      onPressed: () {
        Navigator.pop(context);
      },
      tStyle: theme.textTheme.headline3,
    );
    //
    AlertDialog alert = AlertDialog(
      title: Text("Weet je zeker dat je de laadsessie wilt stoppen?",
          style: theme.textTheme.headline4),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                "Als je de sessie stopt worden alle kosten die je tot nu toe hebt gemaakt in rekening gebracht",
                style: theme.textTheme.subtitle2),
          ],
        ),
      ),
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