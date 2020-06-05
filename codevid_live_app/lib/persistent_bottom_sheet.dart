import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:codevidliveapp/search_bar.dart';
import 'package:codevidliveapp/graph.dart';

class PersistentBottomSheet extends StatefulWidget {
  final Completer<GoogleMapController> mapController;
  final TabController tabController;

  const PersistentBottomSheet({Key key, this.mapController, this.tabController})
      : super(key: key);

  @override
  _PersistentBottomSheetState createState() => _PersistentBottomSheetState();
}

class _PersistentBottomSheetState extends State<PersistentBottomSheet> {
  bool isHalfOpen = true;
  bool forceOpen = false;

  Size _screenSize;

  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_onTabChange);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.tabController.removeListener(_onTabChange);
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    if (widget.tabController.index == 1) {
      setState(() {
        isHalfOpen = false;
      });
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        isHalfOpen = false;
        forceOpen = true;
      });
    } else {
      forceOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (!isHalfOpen) {
          _focusNode.unfocus();
          setState(() {
            isHalfOpen = true;
            forceOpen = false;
            widget.tabController.index = 0;
          });
        }
        return false;
      },
      child: StatefulBuilder(builder: (context, setSheetState) {
        return GestureDetector(
          child: AnimatedContainer(
            width: _screenSize.width,
            decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            curve: Curves.easeOut,
            duration: Duration(milliseconds: 200),
            height: _screenSize.height * (isHalfOpen ? 0.175 : 0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    height: 5,
                    width: isHalfOpen
                        ? _screenSize.width * 0.7
                        : _screenSize.width * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: widget.tabController,
                    children: [
                      SearchBar(
                          focusNode: _focusNode,
                          textEditingController: _textEditingController,
                          mapController: widget.mapController),
                      Graph()
                    ],
                  ),
                )
              ],
            ),
          ),
          onVerticalDragUpdate: (dragDetails) {
            if (dragDetails.delta.dy < 0) {
              // Full open if in half open mode
              if (isHalfOpen) {
                setSheetState(() {
                  isHalfOpen = !isHalfOpen;
                });
              }
            } else if (dragDetails.delta.dy > 0) {
              if (!isHalfOpen && !forceOpen) {
                setSheetState(() {
                  isHalfOpen = !isHalfOpen;
                  widget.tabController.index = 0;
                });
              }
            }
          },
        );
      }),
    );
  }
}
