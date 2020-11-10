import 'package:ez_charge/base/app_page.dart';
import 'package:ez_charge/base/base.dart';
import 'package:firebase_core/firebase_core.dart';
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

class MyApp extends StatelessWidget {
  var email;
  var pswd1;
  var pswd2;
  var succes;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    handleDynamicLinks(context);
    return MaterialApp(
      title: 'EZCharge',
      home: Scaffold(
        appBar: AppBar(
          title: Text('EZCharge '),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                //Registration Form Text
                Text('Charge your car',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                    textAlign: TextAlign.center),

                //Page Description Text

                SizedBox(height: 20.0),
                ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                        color: Colors.yellow[400],
                        child: Text(
                          'Google Pay',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () =>{
                          Fluttertoast.showToast(msg: "You simulated that you have payed"),
                        }
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
