// import 'dart:html';

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../app/global_variables.dart' as globals;

class Invoices extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return invoiceScreen();
  }
}

class invoiceScreen extends State<Invoices> {
  void initState() {
    super.initState();
    initArrays();
    getInformation();
    checkArray();
  }

  var docs;
  var date = [];
  var number = [];
  var amount = [];

  initArrays() {
    date.add('Date');
    number.add('Number');
    amount.add('Amount');
  }

  checkArray() {
    if (date.length > 1) {
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
        .orderBy('stopTime', descending: true)
        .where('uid', isEqualTo: globals.user.uid)
        .get();
    docs = docRef.docs;
    for (var doc in docs) {
      var endDate = DateTime.fromMillisecondsSinceEpoch(
          (doc.get('stopTime').seconds * 1000));
      date.add(DateFormat('yy-MM-dd HH:mm').format(endDate));
      number.add(doc.documentID);
      amount.add(((doc.get('stopTime').seconds - doc.get('startTime').seconds) *
              0.0015)
          .toStringAsFixed(2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Invoices', style: Theme.of(context).textTheme.bodyText1),
        // backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).buttonColor
              ])),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, position) {
          return Column(
            children: <Widget>[
              Container(
                color: (position % 2 != 0 && position !=0) ? Colors.grey.withOpacity(0.3) : null,
                child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                // padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(date[position],
                            style: Theme.of(context).textTheme.subtitle2),
                        alignment: Alignment(0.0, 0.0),
                        height: 50,
                      ),
                      Text(
                        number[position].toString(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        amount[position].toString(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),

                      // FlatButton(onPressed: getInformation, child: null)
                    ],
                  ),
                ),
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              )
            ],
          );
        },
        itemCount: date.length,
      ),
    );
  }
}
