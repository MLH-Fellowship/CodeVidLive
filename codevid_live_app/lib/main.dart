import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';


Future<Position> _future;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> initPos() async {
    Geolocator geolocator = Geolocator()
      ..forceAndroidLocationManager = true;
    GeolocationStatus geolocationStatus = await geolocator
        .checkGeolocationPermissionStatus();
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  void initState() {
    super.initState();
    _future = initPos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("CodeVid_live"),
            ),
            body: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  print(snapshot.data.latitude);
                  return Stack(children: <Widget>[
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              snapshot.data.latitude, snapshot.data.longitude),
                          zoom: 12.0),
                      onMapCreated: _onMapCreated,
                    ),
                  ]
                  );
                })
        )
    );
  }
}
