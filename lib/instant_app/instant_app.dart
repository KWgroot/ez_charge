import 'package:ez_charge/base/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

///instant app

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
                        onPressed: () =>{
                          submitForm(formKey, pswd1, pswd2, email)
                        }
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
