import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

submitForm(GlobalKey<FormState> formKey, String pswd1, String pswd2, String email) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  if (formKey.currentState.validate()) {
    if (pswd1 == pswd2) {
      Fluttertoast.showToast( //This will refer to the coming homepage instead of making a message.
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
    return 'Please enter a valid password';
  } else {
    return null;
  }
}
