import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PushNotificationService extends StatefulWidget {
  @override
  _PushNotificationServiceState createState() => _PushNotificationServiceState();
}

class _PushNotificationServiceState extends State<PushNotificationService> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

// Get Permission on iOS
// On iOS, you must explicitly get permission from the user to
// send notifications. This can be handled when the widget is initialized, or
// better yet, you might strategically request permission when the user is most
// likely to say “yes”.
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'Ga',
            onPressed: () => null,
          ),
        );

        Scaffold.of(context).showSnackBar(snackbar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // // _handleMessages(context);
    return Column(
        // body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
    //   appBar: AppBar(
    //     backgroundColor: Colors.deepOrange,
    //     title: Text('FCM Push Notifications'),
    //
    //    ),
      );
  }


  // /// Get the token, save it to the database for current user
  // _saveDeviceToken() async {
  //   // Get the current user
  //   var user = auth.currentUser;
  //
  //   // Get the token for this device
  //   String fcmToken = await _fcm.getToken();
  //
  //   // Save it to Firestore
  //   if (fcmToken != null) {
  //     var tokens = _db
  //         .collection('users')
  //         .doc(uid)
  //         .collection('tokens')
  //         .doc(fcmToken);
  //
  //     await tokens.setData({
  //       'token': fcmToken,
  //       'createdAt': FieldValue.serverTimestamp(), // optional
  //       'platform': Platform.operatingSystem // optional
  //     });
  //   }
  }