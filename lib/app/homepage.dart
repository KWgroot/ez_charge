  import 'dart:async';

import 'package:ez_charge/base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'design/design.dart';
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
  List<String> date = ["-", "-", "-"];
  List<String> location = ["-", "-", "-"];
  List<String> timeCharged = ["-", "-", "-"];

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _data = value));
    await handleDynamicLinks(context);

    if (_data.split("/")[2] == "ezcharge.page.link") {
      //open AlertDialog
      if (_data != "-1") {
        //add id to global id
        globals.chargingStation = _data.split("/")[3];
        if (isConnected()) {
          _showConnectionDialog();
        } else {
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
      if (globals.chargingStation.isEmpty) {
        hasStation = "";
      } else {
        hasStation = "Laad station: ";
      }
    });
  }

  checkArray() {
    if (date.length > 2) {
      setState(() {});
    } else {
      Timer(Duration(seconds: 2), () {
        checkArray();
      });
    }
  }

  getInformation() async {
    var docs;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot docRef = await firestore
        .collection("chargingSession")
        .orderBy('stopTime', descending: false)
        .where('uid', isEqualTo: globals.user.uid)
        .get();
    docs = docRef.docs;
    for (var doc in docs) {
      var endDate = DateTime.fromMillisecondsSinceEpoch(
          (doc.get('stopTime').seconds * 1000));
      date.insert(
          0, '' + DateFormat('dd-MM-yy HH:mm').format(endDate) + '');
      date.removeAt(3);
      location.insert(0, '' + doc.get('poleId').toString() + '');
      location.removeAt(3);
      timeCharged.insert(
          0,
          '' +
              ((doc.get('stopTime').seconds - doc.get('startTime').seconds) *
                      0.0015)
                  .toStringAsFixed(2) +
              '');
      timeCharged.removeAt(3);
    }
  }

  isConnected() {
    int randomNum = Random().nextInt(5);
    bool connected = randomNum > 3;
    return connected;
  }

  isEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser;
    await user.reload();
    user = await FirebaseAuth.instance.currentUser;
    if (user.emailVerified) {
      setState(() {
        _isButtonDisabled = false;
        _scan();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double heigth =
        MediaQuery.of(context).size.height/3.7;
    double colWidth =
        MediaQuery.of(context).size.width/9.7;
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: new AppBar(
          title: Text('Home', style: theme.textTheme.bodyText1),
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
        body: SingleChildScrollView(
            child: Form(
                child: Column(children: <Widget>[
          SizedBox(height: 5),
          Text('EzCharge',
              style: theme.textTheme.headline1,
              textAlign: TextAlign.center),

          Text(hasStation + globals.chargingStation,
              style: theme.textTheme.bodyText1,
              textAlign: TextAlign.center),

          Text('Recente laad sessies',
              style: theme.textTheme.headline2,
              textAlign: TextAlign.center),
          ConstrainedBox(
            constraints: BoxConstraints.expand(
                width: MediaQuery.of(context).size.width,
                height: heigth),
            child: DataTable(
              showBottomBorder: true,
              dividerThickness: 0,
              columnSpacing: colWidth,
              columns: <DataColumn>[
                DataColumn(
                  label: Text('\nDatum\n',
                      style: theme.textTheme.subtitle1),
                ),
                DataColumn(
                  label: Text('\nLocatie\n',
                      style: theme.textTheme.subtitle1),
                ),
                DataColumn(
                  label: Text('\nTijd geladen\n',
                      style: theme.textTheme.subtitle1),
                ),
              ],
              rows: List<DataRow>.generate(
                3,
                (index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (index % 2 == 0) return Colors.grey.withOpacity(0.3);
                      return null;
                    }),
                    cells: [
                      DataCell(Center(
                          child: Text(
                        date[index],
                        style: theme.textTheme.subtitle1,
                      ))),
                      DataCell(Center(
                          child: Text(
                        location[index],
                        style: theme.textTheme.subtitle1,
                      ))),
                      DataCell(Center(
                          child: Text(
                        timeCharged[index],
                        style: theme.textTheme.subtitle1,
                      )))
                    ]),
              ),
            ),
          ),

          SizedBox(height: 20),
          Text('Start sessie',
              style: theme.textTheme.headline2,
              textAlign: TextAlign.center),

          FlatButton.icon(
              icon: Icon(Icons.qr_code_scanner_rounded, size: 0),
              // alignment: Alignment.center,
              // padding: EdgeInsets.only(right: 125),
              onPressed: () {
                if (_isButtonDisabled) {
                  isEmailVerified();
                } else {
                  _scan();
                }
              }, label: (Icon(Icons.qr_code_scanner_rounded, size: 150)),
              //Open QR code scanner
              ),
          Container(alignment: Alignment.bottomCenter,
              child:
          (_isButtonDisabled)
              ? Text("Verifieer email om te starten",
                  style: theme.textTheme.bodyText2)
              : Text("Gebruikt camera",
                  style: theme.textTheme.subtitle1)
          )
                ]))));
  }

  Future<void> _showMyDialog(String chargingStationId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Start Charging?', style: theme.textTheme.headline2,),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Do you wish to start your charging session at charging station: $chargingStationId?', style: theme.textTheme.headline3),
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Charging(docRef: docRef),
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
          title: Text('Plug your car in!', style:  theme.textTheme.subtitle1),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your car is not plugged in the charging pole.', style: theme.textTheme.subtitle1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Oke', style:  theme.textTheme.subtitle1),
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
