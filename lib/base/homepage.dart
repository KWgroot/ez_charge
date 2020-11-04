
import 'package:ez_charge/instant_app/instant_app.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

import 'charging.dart';

class Homepage extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<Homepage> {
  String _data = "";
  bool sessionStarted = false;
  int poleId = Random().nextInt(1000);
  String docRef = "";

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
        "#000000", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _data = value));

    //open AlertDialog
    if (_data != "-1") {

      String chargingStationId = _data.split("/")[3];

      _showMyDialog(chargingStationId);
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
    super.initState();
    handleDynamicLinks(context);
  }

  Future handleDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data, context);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          // handle link that has been retrieved
          _handleDeepLink(dynamicLink, context);
        }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data, BuildContext context) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      Fluttertoast.showToast(msg: "Chargingstation $deepLink");
      //var isPost = deepLink.pathSegments.contains('post');
      // var isInvite = deepLink.pathSegments.contains('invite');
      // if(isInvite){
      //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
      //       MyApp()), (Route<dynamic> route) => false);
      // }
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
                  Text(
                      'This is a placeholder description.\n'
                          'When we think of a good description it will go here.',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),

                  SizedBox(height: 30),
                  Text('Most recent sessions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                      textAlign: TextAlign.center),
                  Table(
                    border: TableBorder.all(width: 1.0, color: Colors.black),
                    children: [
                      TableRow(children: [
                        TableCell(
                            child: Center(
                                child: Text('\nDate\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)))),
                        TableCell(
                            child: Center(
                                child: Text('\nLocation\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)))),
                        TableCell(
                            child: Center(
                                child: Text('\nTime Charged\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))))
                      ]),
                      TableRow(children: [
                        TableCell(child: Center(child: Text('\nCell 1\n'))),
                        TableCell(child: Center(child: Text('\nCell 2\n'))),
                        TableCell(child: Center(child: Text('\nCell 3\n')))
                      ]),
                      TableRow(children: [
                        TableCell(child: Center(child: Text('\nCell 4\n'))),
                        TableCell(child: Center(child: Text('\nCell 5\n'))),
                        TableCell(child: Center(child: Text('\nCell 6\n')))
                      ]),
                      TableRow(children: [
                        TableCell(child: Center(child: Text('\nCell 7\n'))),
                        TableCell(child: Center(child: Text('\nCell 8\n'))),
                        TableCell(child: Center(child: Text('\nCell 9\n')))
                      ]),
                    ],
                  ),

                  SizedBox(height: 20),
                  Text('Start session',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 36.0),
                      textAlign: TextAlign.center),

                  IconButton(
                    icon: Icon(Icons.qr_code_scanner_rounded, size: 150),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 125),
                    onPressed: () {
                        _scan();
                    },
                    //Open QR code scanner
                  ),

                  SizedBox(height: 90),
                  Text('Requires camera')
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

  startSession() async {
    String docRef;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("chargingSession").add({
      "uid": 'test',
      "poleId": poleId,
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
