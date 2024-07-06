import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/helpers/commons.dart';
import 'package:latlong2/latlong.dart';
import '../helpers/mapbox_handler.dart';
import '../Components/review_ride_bottom_sheet.dart';
import 'package:flutter_cab/helpers/shared_prefs.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ReviewRide extends StatefulWidget {
  final Map modifiedResponse;
  const ReviewRide({super.key, required this.modifiedResponse});

  @override
  State<ReviewRide> createState() => _ReviewRideState();
}

class _ReviewRideState extends State<ReviewRide> {
  // Mapbox Maps SDK related
  final List<CameraOptions> _kTripEndPoints = [];
  late MapboxMap mapboxMapController;
  late CameraOptions _initialCameraPosition;
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;

  PolylineAnnotation? polylineAnnotation;
  PolylineAnnotationManager? polylineAnnotationManager;
  // Directions API response related
  late String distance;
  late String dropOffTime;
  late Map geometry;
  late String rate;

  @override
  void initState() {
    // initialise distance, dropOffTime, geometry
    _initialiseDirectionsResponse();

    // initialise initialCameraPosition, address and trip end points
    LatLng centerCoordinates = getCenterCoordinatesForPolyline(geometry);
    _initialCameraPosition = CameraOptions(
      center: Point(
          coordinates: Position(
              centerCoordinates.longitude, centerCoordinates.latitude)),
      zoom: 8,
    );

    for (String type in ['source', 'destination']) {
      LatLng location = getTripLatLngFromSharedPrefs(type);
      _kTripEndPoints.add(CameraOptions(
          center: Point(
              coordinates: Position(location.longitude, location.latitude))));
    }
    super.initState();
  }

  _initialiseDirectionsResponse() {
    print('response = ${widget.modifiedResponse}');
    if (widget.modifiedResponse['routes'] != null &&
        widget.modifiedResponse['routes'].isNotEmpty) {
      distance = (widget.modifiedResponse['routes'][0]['distance'] / 1000)
          .toStringAsFixed(1);
      rate = (widget.modifiedResponse['routes'][0]['distance'] / 1000 * 9.49)
          .toStringAsFixed(2);
      dropOffTime =
          getDropOffTime(widget.modifiedResponse['routes'][0]['duration']);
      geometry = widget.modifiedResponse['routes'][0]['geometry'];
    } else {
      print(widget.modifiedResponse['message']);
    }
  }

  _onMapCreated(MapboxMap mapboxMapController) async {
    this.mapboxMapController = mapboxMapController;

    mapboxMapController.annotations
        .createPointAnnotationManager()
        .then((pointAnnotationManager) async {
      // Load images into the map style

      final ByteData circleImageData =
          await rootBundle.load('images/circle.png');
      final Uint8List circle = circleImageData.buffer.asUint8List();
      final ByteData squareImageData =
          await rootBundle.load('images/square.png');
      final Uint8List square = squareImageData.buffer.asUint8List();

      var options = <PointAnnotationOptions>[];
      for (var i = 0; i < _kTripEndPoints.length; i++) {
        options.add(PointAnnotationOptions(
          geometry: _kTripEndPoints[i].center as Point,
          image: i == 0 ? circle : square,
          iconSize: 0.1,
        ));
      }
      if (options.isNotEmpty) {
        await pointAnnotationManager.createMulti(options);
        print('Point annotations created');
      } else {
        print('No point annotations to create');
      }
    });

    mapboxMapController.annotations
        .createPolylineAnnotationManager()
        .then((value) {
      polylineAnnotationManager = value;
      createOneAnnotation();
    });
  }

  void createOneAnnotation() {
    var geometry = widget.modifiedResponse['routes'][0]['geometry'];
    if (geometry != null && geometry['coordinates'] != null) {
      // Parsing the coordinates from the geometry
      var coordinates = (geometry['coordinates'] as List)
          .map((coord) => Position(coord[0], coord[1]))
          .toList();

      var lineString = LineString(coordinates: coordinates);

      polylineAnnotationManager
          ?.create(PolylineAnnotationOptions(
              geometry: lineString, lineColor: Colors.red.value, lineWidth: 2))
          .then((value) {
        polylineAnnotation = value;
        print('Polyline annotation created');
      }).catchError((error) {
        print('Error creating polyline annotation: $error');
      });
    } else {
      print('No geometry coordinates found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Review Ride'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: MapWidget(
                key: const ValueKey("mapWidget"),
                styleUri: MapboxStyles.MAPBOX_STREETS,
                cameraOptions: _initialCameraPosition,
                onMapCreated: _onMapCreated,
                mapOptions: MapOptions(
                  contextMode: ContextMode.UNIQUE,
                  constrainMode: ConstrainMode.HEIGHT_ONLY,
                  viewportMode: ViewportMode.DEFAULT,
                  orientation: NorthOrientation.UPWARDS,
                  crossSourceCollisions: true,
                  pixelRatio: MediaQuery.of(context).devicePixelRatio,
                ),
              ),
            ),
            reviewRideBottomSheet(context, distance, dropOffTime, rate),
          ],
        ),
      ),
    );
  }
}
