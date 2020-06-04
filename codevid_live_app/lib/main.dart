import 'package:flutter/material.dart';
import 'package:codevidliveapp/map_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
            child: GestureDetector(
                child: Scaffold(
      body: MapView(),
    ))));
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
