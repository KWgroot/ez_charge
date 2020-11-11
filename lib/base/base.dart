import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var chargingStation = "";

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
    var poleId = deepLink.toString().split("=")[1];
    // Fluttertoast.showToast(msg: "Chargingstation $poleId");
    chargingStation = poleId;
    //var isPost = deepLink.pathSegments.contains('post');
    // var isInvite = deepLink.pathSegments.contains('invite');
    // if(isInvite){
    //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    //       MyApp()), (Route<dynamic> route) => false);
    // }
  }
}

String getChargingStation() {
  // Fluttertoast.showToast(msg: chargingStation);
  return chargingStation;
}
