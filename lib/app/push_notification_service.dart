import 'dart:async';
import 'dart:io';
import 'package:ez_charge/base/charging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'global_variables.dart' as globals;
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
    print("PushNotificationService is initialized");
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print(data);
        _saveDeviceToken();
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'Ga',
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => Charging()
              ));
            },
          ),
        );

        Scaffold.of(context).showSnackBar(snackbar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) => Charging()
        ));

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) => Charging()
        ));
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


  /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    // Get the current user
    var uid = globals.user.uid;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print("fcmToken: $fcmToken");

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }
}