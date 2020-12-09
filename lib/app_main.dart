import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
void otherEntrypoint() => runApp(MyApp());
// void otherEntrypoint() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp();
//   runApp(MaterialApp(
//     title: 'EzCharge',
//     home: MyApp(),
//   ));
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to your app clip!',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to your app clip!'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
