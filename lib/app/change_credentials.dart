import 'package:ez_charge/app/design/btn.dart';
import 'package:ez_charge/base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app/global_variables.dart' as globals;
import 'design/design.dart';

class ChangeCredentials extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZCharge',
      theme: theme,
      home: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          title: Text('EZCharge '),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                //Registration Form Text
                Text('Change your password',
                    style: theme.textTheme.headline1,
                    textAlign: TextAlign.center),

                //Page Description Text
                Text('Fill in the fields below to change your password.',
                    style: theme.textTheme.bodyText1,
                    textAlign: TextAlign.center),

                // Edit text field (Email)
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(labelText: 'Old password'),
                  validator: validatePassword,
                  obscureText: true,
                  style: theme.textTheme.subtitle2,
                ),

                // Edit text field (Password)
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController1,
                  decoration: const InputDecoration(labelText: 'New password'),
                  validator: validatePassword,
                  obscureText: true,
                  style: theme.textTheme.subtitle2,
                ),

                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController2,
                  decoration:
                      const InputDecoration(labelText: 'Repeat new password'),
                  validator: validatePassword,
                  obscureText: true,
                  style: theme.textTheme.subtitle2,
                ),

                // SUBMIT button
                SizedBox(height: 20.0),
                Button(onPressed: () async {EmailAuthCredential credential =
                    EmailAuthProvider.credential(
                        email: globals.user.email,
                        password: _oldPasswordController.text);
                    try {
                      await auth.currentUser.reauthenticateWithCredential(credential);
                    }  catch (FirebaseAuthException) {
                      Fluttertoast.showToast(
                        //This will refer to the coming homepage instead of making a message.
                          msg: "Your old password is wrong.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                    if (_formKey.currentState.validate() &&
                        _passwordController1.text ==
                            _passwordController2.text) {
                      auth.currentUser
                          .updatePassword(_passwordController1.text);
                      Fluttertoast.showToast(
                        //This will refer to the coming homepage instead of making a message.
                          msg: "Your password is changed.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else if (!(_passwordController1.text ==
                        _passwordController2.text)) {
                      Fluttertoast.showToast(
                        //This will refer to the coming homepage instead of making a message.
                          msg: "Your passwords do not match.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }},text: 'Change Password', color: theme.buttonColor, tStyle: theme.textTheme.bodyText1,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
