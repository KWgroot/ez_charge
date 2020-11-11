import 'package:ez_charge/base/base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../base/app_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage()))

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
                        : 'Sign in failed'),
                    style: TextStyle(color: Colors.red),
                  ),
                )
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage()));
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }
}

/*
var email;
  var pswd1;
  var pswd2;
  var succes;
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
                          succes = submitForm(formKey, pswd1, pswd2, email),
                          if (succes) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage()))
                          }
                        }
                    )
                ),
                ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                        color: Colors.yellow[400],
                        child: Text(
                          'Skip Regi',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () =>{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage()))
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
 */