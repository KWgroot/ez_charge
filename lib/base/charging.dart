import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_charge/app/design/btn.dart';
import 'package:ez_charge/app/design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../app/app_page.dart';
import 'package:http/http.dart' as http;
import '../app/global_variables.dart' as globals;

class Charging extends StatefulWidget {
  final String docRef;
  Charging({this.docRef});


  @override
  _ChargingState createState() => _ChargingState();
}

class _ChargingState extends State<Charging> {
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  double chargingCost = 0.0;


  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  @override
  void initState() {
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      setState(() {
        chargingCost = newTick / 60  * 0.015;
        chargingCost.toStringAsFixed(2);
        hoursStr = ((newTick / (60 * 60)) % 60)
            .floor()
            .toString()
            .padLeft(2, '0');
        minutesStr = ((newTick / 60) % 60)
            .floor()
            .toString()
            .padLeft(2, '0');
        secondsStr =
            (newTick % 60).floor().toString().padLeft(2, '0');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RotatedBox(quarterTurns: 2,
            child: WaveWidget(
            config: CustomConfig(
              gradients: [
                [Color.fromRGBO(84, 84, 121, 1), Color.fromRGBO(137, 110, 140, 1)],
                [Color.fromRGBO(0, 92, 133, 1), Color.fromRGBO(0, 197, 220, 1)],
                [Color.fromRGBO(204, 243, 122, 1), Color.fromRGBO(73, 214, 166, 1)],
                [theme.primaryColor, Color.fromRGBO(249, 248, 113, 1)]
              ],
              durations: [35000, 19440, 10800, 6000],
              heightPercentages: [0.20, 0.23, 0.25, 0.30],
              blur: MaskFilter.blur(BlurStyle.solid, 10),
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
            waveAmplitude: 0,
            size: Size(
              double.infinity,
              100,
            ),
          ),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Laadtijd: ",
                style: theme.textTheme.bodyText1,
                ),
                Text("$hoursStr:$minutesStr:$secondsStr",
                    style: TextStyle(
                        fontSize: 48,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)
                ),
              ]),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Kosten: " ,
                  style: theme.textTheme.bodyText1,
                ),
                Text("€$chargingCost",
                    style: TextStyle(
                        fontSize: 48,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)
                ),
              ]),
          Button(
          color: theme.buttonColor,
          onPressed: () {
            stopSession(widget.docRef, context);
          },
          text:
          'STOP CHARGING',
          tStyle: theme.textTheme.bodyText1,
        ),
          WaveWidget(
            config: CustomConfig(
              gradients: [
                [Color.fromRGBO(84, 84, 121, 1), Color.fromRGBO(137, 110, 140, 1)],
                [Color.fromRGBO(0, 92, 133, 1), Color.fromRGBO(0, 197, 220, 1)],
                [Color.fromRGBO(204, 243, 122, 1), Color.fromRGBO(73, 214, 166, 1)],
                [theme.primaryColor, Color.fromRGBO(249, 248, 113, 1)]
              ],
                durations: [35000, 19440, 10800, 6000],
                heightPercentages: [0.20, 0.23, 0.25, 0.30],
                blur: MaskFilter.blur(BlurStyle.solid, 10),
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),
              waveAmplitude: 0,
              size: Size(
                double.infinity,
                100,
              ),
            ),
          ]),
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
        /// Stop Stopwatch
        timerSubscription.cancel();
        timerStream = null;
        setState(() {
          hoursStr = '00';
          minutesStr = '00';
          secondsStr = '00';
        });
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