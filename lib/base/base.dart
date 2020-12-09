import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../app/global_variables.dart' as globals;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  //final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

  FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        // handle link that has been retrieved
        _handleDeepLink(dynamicLink, context);
      }, onError: (OnLinkErrorException e) async {
    print('Link Failed: ${e.message}');
  });
}

Future<bool> getFingerPrintEnabled() async {
  final storage = await SharedPreferences.getInstance();
  globals.enabledFingerprint = storage.getBool("fingerprint");
  return storage.getBool("fingerprint");
}

Future setFingerPrintEnabled(bool enabled) async{
  final storage = await SharedPreferences.getInstance();
  globals.enabledFingerprint = enabled;
  storage.setBool('fingerprint', enabled);
}

void _handleDeepLink(PendingDynamicLinkData data, BuildContext context) {
  final Uri deepLink = data?.link;
  if (deepLink != null) {
    print('_handleDeepLink | deeplink: $deepLink');
    var poleId = deepLink.toString().split("=")[1];
    globals.chargingStation = poleId;
  }
}

String getChargingStation() {
  return globals.chargingStation;
}



