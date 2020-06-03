import 'dart:async';

import 'package:codevidliveapp/models.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:codevidliveapp/persistent_bottom_sheet.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _mapController = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    Scaffold.of(context).showBottomSheet(
        (context) => PersistentBottomSheet(mapController: _mapController),
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))));
  }

  Future<Position> initPos() async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    StaticData.latitude = position.latitude;
    StaticData.longitude = position.longitude;
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initPos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                  target:
                      LatLng(snapshot.data.latitude, snapshot.data.longitude),
                  zoom: 17.0),
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
