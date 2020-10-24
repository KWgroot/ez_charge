import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text('EzCharge',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                          textAlign: TextAlign.center),

                      SizedBox(height: 20),
                      Text('This is a placeholder description.\n'
                          'When we think of a good description it will go here.',
                          style:
                          TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),

                      SizedBox(height: 30),
                      Text('Most recent sessions',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                          textAlign: TextAlign.center),
                      Table(
                        border: TableBorder.all(width: 1.0, color: Colors.black),
                        children: [
                          TableRow(children: [
                            TableCell(child: Center(child: Text('\nDate\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
                            TableCell(child: Center(child: Text('\nLocation\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
                            TableCell(child: Center(child: Text('\nTime Charged\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))))
                          ]),

                          TableRow(children: [
                            TableCell(child: Center(child: Text('\nCell 1\n'))),
                            TableCell(child: Center(child: Text('\nCell 2\n'))),
                            TableCell(child: Center(child: Text('\nCell 3\n')))
                          ]),

                          TableRow(children: [
                            TableCell(child: Center(child: Text('\nCell 4\n'))),
                            TableCell(child: Center(child: Text('\nCell 5\n'))),
                            TableCell(child: Center(child: Text('\nCell 6\n')))
                          ]),

                          TableRow(children: [
                            TableCell(child: Center(child: Text('\nCell 7\n'))),
                            TableCell(child: Center(child: Text('\nCell 8\n'))),
                            TableCell(child: Center(child: Text('\nCell 9\n')))
                          ]),
                        ],
                      ),

                      SizedBox(height: 20),
                      Text('Start session',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0),
                          textAlign: TextAlign.center),

                      IconButton(
                        icon: Icon(Icons.qr_code_scanner_rounded, size: 150),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 125),
                        onPressed: () {
                          //Open QR code scanner
                        }
                      ),

                      SizedBox(height: 90),
                      Text('Requires camera')
                    ]
                )
            )
        )
    );
  }
}