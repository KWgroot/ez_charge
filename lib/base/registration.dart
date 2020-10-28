import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool submitForm(GlobalKey<FormState> formKey, String pswd1, String pswd2, String email) {
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
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Your passwords do not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }
  return false;
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
  } else if (value.toString().length < 8 ){
    return "Your password is to short";
  } else if(!value.contains(new RegExp(r'[A-Z]'))){
    return "Please put a Capital letter in your password";
  } else if (!value.contains(new RegExp(r'[a-z]'))) {
    return "Please put a lowercase letter in your password";
  } else if (!value.contains(new RegExp(r'[0-9]'))){
    return "Please put a number in your password";
  } else if(!value.contains(new RegExp(r"[\$&+,:;=?@#|'<>^*()%!-.]"))) {
    return 'Please put a special character in your password';
  } else {
    return null;
  }
}
