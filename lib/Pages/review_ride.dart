import 'package:flutter/material.dart';
import 'package:flutter_cab/Components/review_ride_bottom_sheet.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ReviewRide extends StatefulWidget {
  final Map modifiedResponse;
  const ReviewRide({super.key, required this.modifiedResponse});

  @override
  State<ReviewRide> createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {
  // Mapbox Maps SDK related

  //Directions API response related

  @override
  void initState() {
    // initialise distance, dropOffTime, geometry
    _initialiseDirectionsResponse();

    // initialise initialCameraPosition, address and tripend points

    super.initState();
  }

  _initialiseDirectionsResponse() {
    //initialise Directions API related variabled
  }

  _onMapCreated(MapboxMapController controller) async {}

  _onStyleLoadedCallback() async {}

  _addSourceAndLineLayer() async {
    // Create a polyLine between source and destination

    // Add new source and linelayer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            'Review Ride',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              reviewRideBottomSheet(context, 'xy.z km', 'a:bc PM'),
            ],
          ),
        ));
  }
}
