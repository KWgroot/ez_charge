import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
            child: Column(
              children: <Widget>[

                //Registration Form Text
                Text(
                    'Registration Form',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                    textAlign: TextAlign.center
                ),

                //Page Description Text
                Text(
                    'Fill in the fields below to create an account.',
                    style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center
                ),

                // Edit text field (Email)
                SizedBox(height: 20.0),
                TextFormField
                  (decoration: new InputDecoration(
                    hintText: 'Email'
                ),
                    onChanged: (val) {

                    }
                ),

                // Edit text field (Password)
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: new InputDecoration(
                        hintText: 'Password'
                    ),
                    obscureText: true,
                    onChanged: (val) {

                    }
                ),

                // Edit text field (Confirm Password)
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: new InputDecoration(
                        hintText: 'Confirm Password'
                    ),
                    obscureText: true,
                    onChanged: (val) {

                    }
                ),

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
                  onPressed: () async {

                  },
                )
               ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
