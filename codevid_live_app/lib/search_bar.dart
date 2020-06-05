import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:codevidliveapp/models.dart';
import 'package:codevidliveapp/api.dart';

class SearchBar extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final Completer<GoogleMapController> mapController;

  const SearchBar(
      {Key key, this.focusNode, this.textEditingController, this.mapController})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<PlaceModel>>();

  List<PlaceModel> placesList = [];

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(onHide: () {
      FocusScope.of(context).unfocus();
    });
    widget.textEditingController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    widget.textEditingController.removeListener(_onTextChange);
    super.dispose();
  }

  void _onTextChange() {
    setState(() {});
  }

  _getMapPlaces() async {
    if (widget.textEditingController.text == "") {
      return "";
    }
    return await Api.getMapPlaces(widget.textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMapPlaces(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != "") {
          var json = jsonDecode(snapshot.data.body);
          placesList = [];
          for (var featureJson in json['features']) {
            placesList.add(PlaceModel.fromJson(featureJson));
          }
        } else if (snapshot.data == "") {
          placesList = [];
        }

        return Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.11,
                  child: TextFormField(
                      controller: widget.textEditingController,
                      focusNode: widget.focusNode,
                      decoration: InputDecoration(
                        suffixIcon: widget.textEditingController.text == ""
                            ? null
                            : IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    widget.textEditingController.text = "";
                                    placesList = [];
                                  });
                                  StaticData.currentLoc = LatLng(
                                      StaticData.latitude,
                                      StaticData.longitude);
                                  animateCamera(StaticData.latitude,
                                      StaticData.longitude);
                                },
                              ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        hintText: "Where do you want to go?",
                        hintStyle: TextStyle(
                          color: Colors.blueGrey[300],
                        ),
                      )),
                )),
            Expanded(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(placesList[index].name),
                        subtitle: Text(placesList[index].details),
                        onTap: () async {
                          widget.textEditingController.text =
                              placesList[index].name;
                          widget.focusNode.unfocus();

                          StaticData.currentLoc = LatLng(
                              placesList[index].latitude,
                              placesList[index].longitude);

                          animateCamera(placesList[index].latitude,
                              placesList[index].longitude);
                        });
                  },
                  itemCount: placesList.length > 3 ? 3 : placesList.length),
            )
          ],
        );
      },
    );
  }

  animateCamera(var latitude, var longitude) async {
    final GoogleMapController controller = await widget.mapController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 13)));
  }
}
