import 'package:ez_charge/app/charging_map_models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  final key = 'AIzaSyDyEt6EzTovdkjAw8GVAr8_mV-HUTge1uk';

  Future<List<Place>> getPlaces(double lat, double lng) async {
    var response = await http.get('https://aronschiphof.github.io/Data/example.json');
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}