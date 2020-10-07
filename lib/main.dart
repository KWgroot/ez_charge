import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var email;
  var pswd1;
  var pswd2;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                Text('Registration Form',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                    textAlign: TextAlign.center),

                //Page Description Text
                Text('Fill in the fields below to create an account.',
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center),

                // Edit text field (Email)
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: new InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    onChanged: (val) {
                      email = val;
                    }),

                // Edit text field (Password)
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: new InputDecoration(hintText: 'Password'),
                    obscureText: true,
                    validator: validatePassword,
                    onChanged: (val) {
                      pswd1 = val;
                    }),

                // Edit text field (Confirm Password)
                SizedBox(height: 20.0),
                TextFormField(
                    decoration:
                        new InputDecoration(hintText: 'Confirm Password'),
                    obscureText: true,
                    validator: validatePassword,
                    onChanged: (val) {
                      pswd2 = val;
                    }),

                // SUBMIT button
                SizedBox(height: 20.0),
                ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                        color: Colors.yellow[400],
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: submitForm)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submitForm() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    if (formKey.currentState.validate()) {
      if (pswd1 == pswd2) {
        Fluttertoast.showToast(
            msg: "Your email is " + email + " and your passwords match",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        firestore.collection("user").add({
          "emailaddress": email.toString(),
          "password": pswd1.toString()
        }).then((value) {});
      } else {
        Fluttertoast.showToast(
            msg: "Your passwords do not match",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter some text';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    } else if (value.toString().length < 8 ||
        !value.contains(new RegExp(r'[A-Z]'), 0) ||
        !value.contains(new RegExp(r'[a-z]'), 0) ||
        !value.contains(new RegExp(r'[0-9]'), 0) ||
        !value.contains(new RegExp(r"[\$&+,:;=?@#|'<>^*()%!-.]"), 0)) {
      return 'Please enter a vaid password';
    } else {
      return null;
    }
  }
}
