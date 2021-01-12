import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChargingMap extends StatefulWidget {
  @override
  ChargingMapScreen createState() => ChargingMapScreen();
}

class ChargingMapScreen extends State<ChargingMap> {
  var _data;

  Route<dynamic> generateRoute(RouteSettings chargingMap) {
    return MaterialPageRoute(
        builder: (BuildContext context) {
          //some custom code
          return _data[chargingMap.name](context);
        },
        settings: chargingMap
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        ),
    );
  }
}
