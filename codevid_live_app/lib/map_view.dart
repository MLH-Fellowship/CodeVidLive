import 'dart:async';
import 'dart:convert';

import 'package:codevidliveapp/api.dart';
import 'package:codevidliveapp/models.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:core';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:codevidliveapp/persistent_bottom_sheet.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with SingleTickerProviderStateMixin {
  Future<Position> _future;
  Set<Marker> markers = Set();
  Set<Circle> circles = Set();
  Geolocator geolocator;

  Completer<GoogleMapController> _mapController = Completer();
  TabController _tabController;

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    Scaffold.of(context).showBottomSheet(
        (context) => PersistentBottomSheet(
            mapController: _mapController, tabController: _tabController),
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

    StaticData.currentLoc = LatLng(StaticData.latitude, StaticData.longitude);
    setState(() {
      markers.add(Marker(
          markerId: MarkerId('requested'),
          position: StaticData.currentLoc,
          infoWindow: InfoWindow(),
          onTap: () {
            _tabController.index = 1;

          }));
    });

    return position;
  }

  void _getMarkerInfo() async {
    LatLng currentLoc = StaticData.currentLoc;

    markers.clear();
    setState(() {
      markers.add(Marker(
          markerId: MarkerId('requested'),
          position: currentLoc,
          infoWindow: InfoWindow(),
          onTap: () {
            _tabController.index = 1;
          }));
    });

    var response =
        await Api.getPredictions(currentLoc.longitude, currentLoc.latitude);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response);

      // Clear previous points
      circles.clear();
      markers.clear();

      // Generate random circle id
      var rng = new Random();
      var nearby = jsonResponse['nearby'];
      setState(() {
        for (var i = 0; i < nearby.length; i++) {
          String id = rng.nextInt(100).toString() + rng.nextInt(100).toString();

          circles.add(
            Circle(
              circleId: CircleId('circle$i$id'),
              center: LatLng(nearby[i]['latitude'], nearby[i]['longitude']),
              radius: nearby[i]['chance'] * 40000,
              strokeColor: nearby[i]['chance'] < 0.30
                  ? Colors.green
                  : nearby[i]['chance'] < 0.60 ? Colors.yellow : Colors.red,
              strokeWidth: (nearby[i]['chance'] * 100).toInt(),
            ),
          );

          markers.add(Marker(
            markerId: MarkerId('marker$i$id'),
            position: LatLng(nearby[i]['latitude'], nearby[i]['longitude']),
          ));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _future = initPos();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: StaticData.currentLoc, zoom: 12.0),
              onMapCreated: _onMapCreated,
              markers: markers,
              circles: circles,
              zoomControlsEnabled: false,
              onCameraIdle: _getMarkerInfo,
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
