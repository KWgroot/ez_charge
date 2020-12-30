import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:ez_charge/app/onboarding/onboarding.dart';
import 'package:ez_charge/base/base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_page.dart';
import 'global_variables.dart';
import 'registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'global_variables.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: TITLE,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      home: LoginPage(),
    );
  }
}
//try to get device ID, Internet required!
//ID in DB? Yes > no onboardingscreen
//NO? > show onboardingscreen

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  bool _success;
  bool _canCheckBiometric = false;
  bool isAuthorized = false;

  String _userEmail;
  String _authorized = "Geen toegang";

  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  @override
  Widget build(BuildContext context) {
    onBoarding();
    if(!isAuthorized){
      _authorizeNow();
    }

    return MaterialApp(
      title: 'EZCharge',
      home: Scaffold(
        appBar: AppBar(
          title: Text('EZCharge '),
        ),
        body: bodyWidget()
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  ///This function will run every time when the app starts.
  void onBoarding() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String id = await getDeviceId();
    String deviceIdFromFirestore = "";
    bool idExist = false;

    await firestore.collection(COLLECTION_ONBOARDING).get().then((value) =>
    {
      //need to call to update globals.enabledFingerprint variable
      getEnableBiometric(),
      //Loop
      value.docs.forEach((results) {

        //check if the list with ids is not empty
        //else it will create a collection and upload the device id for first time
        //and redirect user to the onboarding screen.
        if (value.docs.length > 0) {
          deviceIdFromFirestore = results.data()["device_id"] ;

          if(deviceIdFromFirestore == id){
            idExist = true;
          }
        } else{
          firestore.collection(COLLECTION_ONBOARDING).add({
            "device_id": id
          });

          Navigator.push(context, MaterialPageRoute(builder: (context) => Onboarding()));
        }

      }),
      //If list exist, and user doesnt, then run
      if(!idExist){
        firestore.collection(COLLECTION_ONBOARDING).add({
          "device_id": id
        }),
        Navigator.push(context, MaterialPageRoute(builder: (context) => Onboarding())),
        idExist = true
      }
    });
  }

  void _signInWithEmailAndPassword(bool fingerprintEnabled) async {
    final User user = (await auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;

    //If fingerprint is enabled, then it will fill in the credentials automatically,
    //in the email and password text boxes. Which is unwanted.
    if(fingerprintEnabled){
      _emailController.clear();
      _passwordController.clear();
    }

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

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try{
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (error){
      print(error);
    }

    if(!mounted){
      return;
    }

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _authorizeNow() async {
    final storage = await SharedPreferences.getInstance();

    try{
      if(await getEnableBiometric()){

        const iosStrings = const IOSAuthMessages(
            cancelButton: "annuleer",
            goToSettingsButton: 'Instellingen',
            goToSettingsDescription: 'Stel uw Touch ID of Face ID in',
            lockOut: "Herstel uw Touch ID of Face ID"
        );

        const androidStrings = const AndroidAuthMessages(
            cancelButton: "annuleer",
            goToSettingsButton: "instellingen",
            goToSettingsDescription: "Stel uw vingerafdruk of gezichtsherkenning in",
            signInTitle: "Inloggen"
        );

        try{
          isAuthorized = await _localAuthentication.authenticateWithBiometrics(
              localizedReason: "Log in met uw vingers",
              useErrorDialogs: false,
              iOSAuthStrings: iosStrings,
              androidAuthStrings: androidStrings,
              stickyAuth: true
          );
        } on PlatformException catch (error){
          print(error);
        }

        if(!mounted){
          return;
        }

        setState(() {
          if(isAuthorized){
            _authorized = "Bevoegd, welkom";
            //TODO WARNING retrieve email and password from local storage
            _emailController.text = storage.getString("email");
            _passwordController.text = storage.getString("password");

            _signInWithEmailAndPassword(true);
          }else{
            _authorized = "Geen toegang";
          }
        });
      }else{
        print("Biometric not enabled");
      }
    }catch(e){
      setEnableBiometric(false);
      throw Exception("Need to setup biometric");
    }
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;

    try{
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();

    } on PlatformException catch (error){
      print(error);
    }

    if(!mounted){
      return;
    }

    setState(() {
      _availableBiometricTypes = listOfBiometrics;
    });
  }

  getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      // Android-specific code
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;

    } else if (Platform.isIOS) {
      // iOS-specific code
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    }

  }

  Widget bodyWidget() {
    return SingleChildScrollView(
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
                height: 40.0,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    color: Colors.yellow[400],
                    child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0
                        )
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _signInWithEmailAndPassword(false);
                        //TODO WARNING Email and password will be saved as plain text in local storage for logging in using fingerprint or face recognition. Firebase requires users to log in with email and password.
                        final storage = await SharedPreferences.getInstance();
                        storage.setString("email", _emailController.text);
                        storage.setString("password", _passwordController.text);
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
                    ? ''
                    : 'De ingevoerde gebruikersnaam en/of het wachtwoord is onjuist, probeer het opnieuw'),
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
                height: 40.0,
                child: RaisedButton(
                    color: Colors.yellow[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                    }
                )
            ),
          ],
        ),
      ),
    );
  }
}
