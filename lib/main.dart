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
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                    onChanged: (val) {

                    }
                ),
                SizedBox(height: 20.0),
                TextFormField(
                    obscureText: true,
                    onChanged: (val) {

                    }
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.yellow[400],
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {

                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
