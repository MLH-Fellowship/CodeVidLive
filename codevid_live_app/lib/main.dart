import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:charts_flutter/flutter.dart' as charts;


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
              title: Text("CodeVidLive"),
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
                    FloatingActionButton(
                      onPressed: (){
                        visualizationGraph(context);
                      },)
                  ]
                  );
                }),
    )
    );
  }
}


// Charts

void visualizationGraph(context){
    showModalBottomSheet(
    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(10.0),
      ),
    context: context,
    backgroundColor:Colors.white,
    builder: (context) => Container(    
    height: 750,
    padding: const EdgeInsets.all(20.0),
    child: ListView(
        children: <Widget>[        
          Container(
            padding: const EdgeInsets.only(left:95,right: 95, bottom: 20),
            child:Divider(
                  color: Colors.black54,
                  thickness: 3,
                ),
              ),
          Text(
            "Monthly Covid Cases",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25        
            ),
          ),
          SizedBox(height: 20,),
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: 250.0),
            child: charts.BarChart(
              _getSeriesData(), 
              animate: true,
              
            ),
          ),
          
        ],
      ),
              )
              
    );
}

class CovidData {
  String month;
  int cases;
  CovidData({
    @required this.month, 
    @required this.cases
  });
}

final List<CovidData> data = [
    CovidData(
      month: 'Jan',
      cases: 50000
    ),
    CovidData(
      month: 'Feb',
      cases: 60000
    ),
    CovidData(
      month: 'March',
      cases: 70000
    ),
    CovidData(
      month: 'April',
      cases: 80000
    ),
    CovidData(
      month: 'May',
      cases: 50000
    ),
 
  ];
  
  _getSeriesData() {
    List<charts.Series<CovidData, String>> series = [
      charts.Series(
        id: "Cases",
        data: data,
        domainFn: (CovidData series, _) => series.month.toString(),
        measureFn: (CovidData series, _) => series.cases
      )
    ];
    return series;
}