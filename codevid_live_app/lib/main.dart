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
