import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer';


Position position;

// You can ignore this function - it's here to visualize delay time in this example.
void countSeconds(int s) {
  for (var i = 1; i <= s; i++) {
    Future.delayed(Duration(seconds: i), () => print(position.toString()));
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  GoogleMapController mapController;
//  LatLng _center = LatLng(position.latitude, position.longitude);
  LatLng _center;
//  final LatLng _center = LatLng(43, 45);
  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }

  Future<void> initPos() async{
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    GeolocationStatus geolocationStatus  = await geolocator.checkGeolocationPermissionStatus();
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _center = LatLng(position.latitude, position.longitude);
  }

  @override
  void initState(){
    super.initState();
    initPos();
    countSeconds(4);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}