import 'package:ez_charge/app/charging_map_models/geometry.dart';

class Place{
  final String name;
  final String vicinity;
  final Geometry geometry;

  Place({this.geometry, this.name, this.vicinity});

  Place.fromJson(Map<dynamic, dynamic> parsedJson)
    :name = parsedJson['name'],
    vicinity = parsedJson['vicinity'],
    geometry = Geometry.fromJson(parsedJson['geometry']);
}