import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PushNotificationService extends StatefulWidget {
  @override
  _PushNotificationServiceState createState() => _PushNotificationServiceState();
}

class _PushNotificationServiceState extends State<PushNotificationService> {
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
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
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
    // _handleMessages(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('FCM Push Notifications'),
      ),
    );
  }


  // /// Get the token, save it to the database for current user
  Future _saveDeviceToken() async {
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
  }
  //   // Get the current user
  //   String uid = 'jeffd23';
  //   // FirebaseUser user = await _auth.currentUser();
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
  //     await tokens.set({
  //       'token': fcmToken,
  //       'createdAt': FieldValue.serverTimestamp(), // optional
  //       'platform': Platform.operatingSystem // optional
  //     });
  //   }
  // }
}