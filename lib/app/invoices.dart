import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app/global_variables.dart' as globals;

class Invoices extends StatelessWidget {

  var date = ['Date', 'test', 'test2'];
  var number = ['Number' , 0 , 1];
  var amount = ['Amount', 10.00, 11.03];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, position) {
          return Column(
            children: <Widget>[
              Padding(padding:
              const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(date[position]), alignment: Alignment(0.0, 0.0), height: 50,),
                      Text(number[position].toString()),
                      Text(amount[position].toString())
                    ],
                  )
              ),
              Divider(
                height: 2.0,
                color: Colors.grey,
              )
            ],
          );
        },
        itemCount: 3,
      ),
    );
  }
}
getInformation(){
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore.collection("chargingSession").orderBy('stopTime').orderBy('startTime').orderBy('poleid').startAt(globals.user.uid);

}