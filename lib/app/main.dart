import 'package:ez_charge/app/push_notification_service.dart';
import 'package:ez_charge/base/base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../base/app_page.dart';
import 'registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'global_variables.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'EzCharge',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EzCharge',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
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
                PushNotificationService(),
                //Registration Form Text
                Text('Welcome to EzCharge',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                    textAlign: TextAlign.center),

                //Page Description Text
                Text('Fill in the fields below to login.',
                    style: TextStyle(fontSize: 20.0),
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
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                ),

                // SUBMIT button
                SizedBox(height: 20.0),
                ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                        color: Colors.yellow[400],
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _signInWithEmailAndPassword();
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
                        ? 'Successfully signed in ' + _userEmail
                        : 'Incorrect user credentials, try again.'),
                    style: TextStyle(color: Colors.red),
                  ),
                ),

                SizedBox(height: 60.0),
                Text('Dont have an account yet? Register here.',
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center),

                SizedBox(height: 20.0),
                ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                        color: Colors.yellow[400],
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                        }
                    )
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
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    final User user = (await auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        globals.user = user;
        Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage()));
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }
}