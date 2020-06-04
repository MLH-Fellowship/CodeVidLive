import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart';

import 'package:codevidliveapp/models.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final List<CovidData> data = [
    CovidData(month: 'Jan', cases: 50000),
    CovidData(month: 'Feb', cases: 60000),
    CovidData(month: 'March', cases: 70000),
    CovidData(month: 'April', cases: 80000),
    CovidData(month: 'May', cases: 50000),
  ];

  _getSeriesData() {
    List<Series<CovidData, String>> series = [
      Series(
          id: "Cases",
          data: data,
          domainFn: (CovidData series, _) => series.month.toString(),
          measureFn: (CovidData series, _) => series.cases)
    ];
    return series;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 750,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Center(
            child: Text(
              "Monthly Covid Cases around marker",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: 200.0),
            child: BarChart(
              _getSeriesData(),
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
}
