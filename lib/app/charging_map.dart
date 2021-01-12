import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ChargingMap extends StatefulWidget {
  @override
  ChargingMapScreen createState() => ChargingMapScreen();
}

class ChargingMapScreen extends State<ChargingMap> {
  var _data;
  final CameraPosition _initialPosition = CameraPosition(target: LatLng(52.0942726655464, 5.116191956015984));
  GoogleMapController _controller;

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
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition:
                  CameraPosition(target: LatLng(52.370187, 4.897326),
                  zoom: 10.0),
                  zoomGesturesEnabled: true,
              ),
            )
          ],
        )
    );
  }
}
