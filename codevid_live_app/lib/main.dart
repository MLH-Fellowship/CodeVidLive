import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart' show Color, Colors;

Future<Position> _future;
List<Polyline> _polyLine = [];
Set<Marker> markers = Set();
Set<Circle> circles = Set();
LatLng currentLoc;
Geolocator geolocator;

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
    geolocator = Geolocator()..forceAndroidLocationManager = true;
    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void testGetLocation() {
    var response =
        '{"nearby":[{"longitude":116.41576166666664,"chance":0.59,"latitude":40.042975},{"longitude":120.41576166666664,"chance":0.20,"latitude":43.042975},{"longitude":114.41576166666664,"chance":0.90,"latitude":43.042975}],"requested":{"longitude":-63.53797,"chance":0.59,"latitude":-81.46996}}';
    var rng = new Random();
    var jsonResponse = convert.jsonDecode(response);
    List<dynamic> nearby = jsonResponse['nearby'];
    circles.clear();
    setState(() {
      for (var i = 0; i < nearby.length; i++) {
        circles.add(
          Circle(
            circleId: CircleId('value1' +
                rng.nextInt(100).toString() +
                rng.nextInt(100).toString()),
            center: LatLng(nearby[i]['latitude'], nearby[i]['longitude']),
            radius: nearby[i]['chance'] * 40000,
            strokeColor: nearby[i]['chance'] < 0.30
                ? Colors.green
                : nearby[i]['chance'] < 0.60 ? Colors.yellow : Colors.red,
            strokeWidth: (nearby[i]['chance'] * 100).toInt(),
          ),
        );
      }
    });
  }

  void onTapMap(LatLng point) {
    markers.clear();
    setState(() {
      currentLoc = point;
      markers.addAll([
        Marker(
          markerId: MarkerId('value'),
          position: currentLoc,
        )
      ]);
    });
  }

  void postLocation() async {
    var url = '127.0.0.1/api/prediction?latitude=' +
        currentLoc.latitude.toString() +
        '&longitude=' +
        currentLoc.longitude.toString();
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var rng = new Random();
      var jsonResponse = convert.jsonDecode(response.body);
      List<dynamic> nearby = jsonResponse['nearby'];
      circles.clear();
      setState(() {
        for (var i = 0; i < nearby.length; i++) {
          circles.add(
            Circle(
              circleId: CircleId('value1' +
                  rng.nextInt(100).toString() +
                  rng.nextInt(100).toString()),
              center: LatLng(nearby[i]['latitude'], nearby[i]['longitude']),
              radius: nearby[i]['chance'] * 40000,
              strokeColor: nearby[i]['chance'] < 0.30
                  ? Colors.green
                  : nearby[i]['chance'] < 0.60 ? Colors.yellow : Colors.red,
              strokeWidth: (nearby[i]['chance'] * 100).toInt(),
            ),
          );
        }
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
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
        title: Text("CodeVidLive"),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            currentLoc = currentLoc == null
                ? LatLng(snapshot.data.latitude, snapshot.data.longitude)
                : currentLoc;
            markers.addAll([
              Marker(
                markerId: MarkerId('value'),
                position: currentLoc,
              )
            ]);
            return Stack(children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 12.0),
                onMapCreated: _onMapCreated,
                markers: markers,
                polylines: _polyLine.toSet(),
                circles: circles,
                onCameraIdle: testGetLocation,
                onTap: onTapMap,
              ),
              FloatingActionButton(
                onPressed: () {
                  visualizationGraph(context);
                },
              )
            ]);
          }),
    ));
  }
}

// Charts

void visualizationGraph(context) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Container(
            height: 750,
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.only(left: 95, right: 95, bottom: 20),
                  child: Divider(
                    color: Colors.black54,
                    thickness: 3,
                  ),
                ),
                Text(
                  "Monthly Covid Cases",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(
                  height: 20,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 250.0),
                  child: charts.BarChart(
                    _getSeriesData(),
                    animate: true,
                  ),
                ),
              ],
            ),
          ));
}

class CovidData {
  String month;
  int cases;
  CovidData({@required this.month, @required this.cases});
}

final List<CovidData> data = [
  CovidData(month: 'Jan', cases: 50000),
  CovidData(month: 'Feb', cases: 60000),
  CovidData(month: 'March', cases: 70000),
  CovidData(month: 'April', cases: 80000),
  CovidData(month: 'May', cases: 50000),
];

_getSeriesData() {
  List<charts.Series<CovidData, String>> series = [
    charts.Series(
        id: "Cases",
        data: data,
        domainFn: (CovidData series, _) => series.month.toString(),
        measureFn: (CovidData series, _) => series.cases)
  ];
  return series;
}
