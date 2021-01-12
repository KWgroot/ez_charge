import 'dart:async';

import 'package:ez_charge/base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'global_variables.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../base/charging.dart';

class Homepage extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<Homepage> {
  String _data = "";
  bool sessionStarted = false;
  int poleId = Random().nextInt(1000);
  String docRef = "";
  bool _isButtonDisabled;
  String hasStation = "";

  var docs;
  List<String> date = ["\n-\n", "\n-\n", "\n-\n"];
  List<String> location = ["\n-\n", "\n-\n", "\n-\n"];
  List<String> timeCharged = ["\n-\n", "\n-\n", "\n-\n"];

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _data = value));
    await handleDynamicLinks(context);

    if(_data.split("/")[2] == "ezcharge.page.link"){
      //open AlertDialog
      if (_data != "-1") {
        //add id to global id
        globals.chargingStation = _data.split("/")[3];
        if(isConnected()){
          _showConnectionDialog();
        }else{
          _showMyDialog(globals.chargingStation);
        }
      }

    }

  }
  String _linkMessage;
  bool _isCreatingLink = false;
  String _testString =
      "To test: long press link and then copy and click from a non-browser "
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      "is properly setup. Look at firebase_dynamic_links/README.md for more "
      "details.";

  @override
  void initState() {
    User user = FirebaseAuth.instance.currentUser;
    super.initState();

    //for asking first time biometric permission
    getPermission();

    if (user.emailVerified) {
      _isButtonDisabled = false;
    } else {
      _isButtonDisabled = true;
    }

    getInformation();
    checkArray();

    Timer(Duration(seconds: 2), () {
      setState(() {});

      //check if chargingStation var is empty. if yes, then get chargingStation
      //id via deeplink.
      if(globals.chargingStation.isEmpty){
        hasStation = "";
      }else{
        hasStation = "Laad station: ";
      }

  });

  }

  checkArray(){
    if(date.length > 2){
      setState(() {});
    } else {
      Timer(Duration(seconds: 2), () {checkArray();});
    }
  }

  getInformation() async{
    var docs;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot docRef = await firestore.collection("chargingSession").orderBy('stopTime', descending: false).where('uid', isEqualTo: globals.user.uid).get();
    docs = docRef.docs;
    for(var doc in docs){
      var endDate = DateTime.fromMillisecondsSinceEpoch((doc.get('stopTime').seconds * 1000));
      date.insert(0, '\n' + DateFormat('dd-MM-yy HH:mm').format(endDate) + '\n');
      date.removeAt(3);
      location.insert(0, '\n' + doc.get('poleId').toString() + '\n');
      location.removeAt(3);
      timeCharged.insert(0, '\n' + ((doc.get('stopTime').seconds - doc.get('startTime').seconds) * 0.0015).toStringAsFixed(2) + '\n');
      timeCharged.removeAt(3);
    }
  }


  isConnected(){
    int randomNum = Random().nextInt(5);
    bool connected = randomNum>3;
    return connected;
  }

  isEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser;
    await user.reload();
    user = await FirebaseAuth.instance.currentUser;
    if(user.emailVerified){
      setState(() {
        _isButtonDisabled = false;
        _scan();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
                child: Column(children: <Widget>[
                  SizedBox(height: 20),
                  Text('EzCharge',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 36.0),
                      textAlign: TextAlign.center),

                  SizedBox(height: 20),
                  Text(hasStation + globals.chargingStation,
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center),
                  Text(
                      'Welkom bij EzCharge, de slimste manier\n om op te laden.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),

                  SizedBox(height: 30),
                  Text('Recente laad sessies',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                      textAlign: TextAlign.center),
                  Table(
                    border: TableBorder.all(width: 1.0, color: Colors.black),
                    children: [
                      TableRow(children: [
                        TableCell(
                            child: Center(
                                child: Text('\nDatum\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)))),
                        TableCell(
                            child: Center(
                                child: Text('\nLocatie\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)))),
                        TableCell(
                            child: Center(
                                child: Text('\nTijd geladen\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))))
                      ]),
                      TableRow(children: [
                        TableCell(child: Center(child: Text(date[0]))),
                        TableCell(child: Center(child: Text(location[0]))),
                        TableCell(child: Center(child: Text(timeCharged[0])))
                      ]),
                      TableRow(children: [
                        TableCell(child: Center(child: Text(date[1]))),
                        TableCell(child: Center(child: Text(location[1]))),
                        TableCell(child: Center(child: Text(timeCharged[1])))
                      ]),
                      TableRow(children: [
                        TableCell(child: Center(child: Text(date[2]))),
                        TableCell(child: Center(child: Text(location[2]))),
                        TableCell(child: Center(child: Text(timeCharged[2])))
                      ]),
                    ],
                  ),

                  SizedBox(height: 20),
                  Text('Start sessie',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 36.0),
                      textAlign: TextAlign.center),

                  IconButton(
                    icon: Icon(Icons.qr_code_scanner_rounded, size: 150),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 125),
                    onPressed: (){
                      if(_isButtonDisabled){
                        isEmailVerified();
                      } else {
                        _scan();
                      }
                    }
                    //Open QR code scanner
                  ),

                  SizedBox(height: 90),
                  (_isButtonDisabled)
                      ? Text("Verifieer email om te starten",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                  )
                          : Text("Gebruikt camera")
                  // THIS LINE IS REQUIRED
                  // FOR SOME REASON ICONS ARE NOT SEEN AS FILLING
                  // MEANING THAT WHEN YOU PUT THE PHONE SIDEWAYS
                  // IT WONT SCROLL ALL THE WAY DOWN WITHOUT THIS.
                ]))));
  }

  Future<void> _showMyDialog(String chargingStationId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Start Charging?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you wish to start your charging session at charging station: $chargingStationId?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                _data = "";
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                docRef = await startSession();
                globals.chargingStation = chargingStationId.toString();
                print(docRef);
                Navigator.of(context).push(MaterialPageRoute
                  (builder: (context) => Charging(docRef : docRef),
                ));
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showConnectionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Plug your car in!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your car is not plugged in the charging pole.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Oke'),
              onPressed: () {
                _data = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  startSession() async {
    String docRef;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("chargingSession").add({
      "uid": globals.user.uid,
      "poleId": globals.chargingStation,
      "startTime": DateTime.now(),
      "stopTime": "",
    }).then((value) {
      docRef = value.id;
    });
    Navigator.of(context).pop();
    sessionStarted = true;
    return docRef;
  }


}
