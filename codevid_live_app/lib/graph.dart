import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart';

import 'package:codevidliveapp/models.dart';
import 'package:codevidliveapp/api.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final List<CovidData> data = [];

  _getSeriesData() async {
    var response = await Api.getTimeSeries(
        StaticData.currentLoc.longitude, StaticData.currentLoc.latitude);
    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    data.clear();
    for (var covidData in jsonResponse['points']) {
      data.add(CovidData(
          month: covidData['month'].substring(0, 3), cases: covidData['noOfInfections']));
    }

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
            child: FutureBuilder(
                future: _getSeriesData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return BarChart(
                      snapshot.data,
                      animate: true,
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ),
        ],
      ),
    );
  }
}
