import 'package:ez_charge/base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app/global_variables.dart' as globals;

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
      home: Scaffold(
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                    textAlign: TextAlign.center),

                //Page Description Text
                Text('Fill in the fields below to change your password.',
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center),

                // Edit text field (Email)
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(labelText: 'Old password'),
                  validator: validatePassword,
                  obscureText: true,
                ),

                // Edit text field (Password)
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController1,
                  decoration: const InputDecoration(labelText: 'New password'),
                  validator: validatePassword,
                  obscureText: true,
                ),

                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController2,
                  decoration:
                      const InputDecoration(labelText: 'Repeat new password'),
                  validator: validatePassword,
                  obscureText: true,
                ),

                // SUBMIT button
                SizedBox(height: 20.0),
                ButtonTheme(
                    minWidth: double.infinity,
                    height: 40.0,
                    child: RaisedButton(
                        color: Colors.yellow[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Change Password',
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        onPressed: () async {
                          EmailAuthCredential credential =
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
                          }
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
