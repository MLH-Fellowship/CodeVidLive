import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  String name;
  String details;

  var longitude;
  var latitude;

  PlaceModel({this.name, this.details});

  PlaceModel.fromJson(Map<String, dynamic> json) {
    var nameArray = json['context'];
    int contextLength = nameArray == null ? 0 : nameArray.length;
    this.name = json['text'];
    if (contextLength >= 2) {
      this.details = [
        nameArray[contextLength - 2]['text'],
        nameArray[contextLength - 1]['text']
      ].join(', ');
    } else if (contextLength == 1) {
      this.details = nameArray[0]['text'];
    } else {
      this.details = "";
    }

    var coordinates = json['geometry']['coordinates'];
    // MapBox follow (long, lat) instead of conventional (lat, long)
    this.longitude = coordinates[0];
    this.latitude = coordinates[1];
  }
}

class CovidData {
  String month;
  int cases;

  CovidData({this.month, this.cases});
}

class StaticData {
  static var latitude;
  static var longitude;
  static bool showGraph = false;

  static LatLng currentLoc;
}
