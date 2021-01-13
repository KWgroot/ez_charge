import 'package:ez_charge/app/main.dart';
import 'package:ez_charge/app/reCaptcha.dart';
import 'package:ez_charge/base/base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  bool _success;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZCharge',
      home: Scaffold(
        appBar: new AppBar(
          title: Text('EzCharge'),
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                //Registration Form Text
                Text('Register for a new EzCharge account.',
                    style:
                    Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center),

                //Page Description Text
                Text('Fill in the fields below to register.',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center),

                // Edit text field (Email)
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),

                // Edit text field (Password)
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController1,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: validatePassword,
                  obscureText: true,
                ),

                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController2,
                  decoration: const InputDecoration(
                      labelText: 'Repeat password'),
                  validator: validatePassword,
                  obscureText: true,
                ),

                // SUBMIT button
                SizedBox(height: 20.0),
                ButtonTheme(
                    minWidth: double.infinity,
                    height: 40.0,
                    child: RaisedButton(
                        color: Theme.of(context).buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          'Register',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate() && _passwordController1.text == _passwordController2.text) {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context){
                                    return Captcha((String code)=>print("Code returned: "+code));
                                  }
                              ),
                            );
                            _register();
                          } else if (!(_passwordController1.text == _passwordController2.text)) {
                            Fluttertoast.showToast( //This will refer to the coming homepage instead of making a message.
                                msg: "Your passwords do not match.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                    )
                ),

                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _success == null
                        ? ''
                        : (_success
                        ? 'Successfully registered ' + _userEmail
                        : 'Registration failed'),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  void _register() async {
    final User user = (await
    auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController1.text,
    )
    ).user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        sendVerificationEmail();
      });
    } else {
      setState(() {
        _success = true;
      });
    }
  }

  void sendVerificationEmail() async {
    User user = FirebaseAuth.instance.currentUser;
    if (!user.emailVerified) {
      Fluttertoast.showToast(
          msg: "Er is een email verificatie link verstuurd naar " +
              _userEmail +
              ".",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(_userEmail);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      await user.sendEmailVerification();
    }
  }
}