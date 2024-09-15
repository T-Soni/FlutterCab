import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/helpers/commons.dart';
import 'package:flutter_cab/helpers/mapbox_handler.dart';
import 'package:flutter_cab/helpers/shared_prefs.dart';
import 'package:flutter_cab/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../helpers/dio_exceptions.dart';

class RequestRide extends StatefulWidget {
  final Map modifiedResponse;
  const RequestRide({super.key, required this.modifiedResponse});

  @override
  State<RequestRide> createState() => _RequestRideState();
}

class _RequestRideState extends State<RequestRide> {
  String apiKey = dotenv.env['GOOGLE_API_KEY']!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  void deleteRideRequest() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DatabaseReference rideRequestRef =
            _database.ref('ride_requests/${user.uid}');

        await rideRequestRef.remove();

        print('Ride request deleted successfully!');
      }
    } catch (e) {
      print('Error deleting ride request: $e');
    }
  }

  Dio _dio = Dio();
  var destinationLocation =
      json.decode(sharedPreferences.getString('destination')!)['location'];

  //double latitude = destinationLocation['coordinates'][0];
  //double longitude = destinationLocation['longitude'];

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
    super.initState();
    // initialise distance, dropOffTime, geometry
    _initialiseDirectionsResponse();

    // initialise initialCameraPosition, address and trip end points
    var centerCoordinates = getCenterCoordinatesForPolyline(geometry);
    _initialCameraPosition = CameraOptions(
      center: Point(
          coordinates: Position(
              centerCoordinates.longitude, centerCoordinates.latitude)),
      zoom: 10,
    );

    for (String type in ['source', 'destination']) {
      var location = getTripLatLngFromSharedPrefs(type);
      _kTripEndPoints.add(CameraOptions(
          center: Point(
              coordinates: Position(location.longitude, location.latitude))));
    }
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

  void cancelRide() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(child: Text('Cancel Ride?')),
              content: const Text(
                'Please wait while we find a cab for you ...',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    TextButton(
                      // style: const ButtonStyle(
                      //     backgroundColor:
                      //         MaterialStatePropertyAll(Colors.amberAccent)),
                      onPressed: () async {
                        deleteRideRequest();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var colorizeColors = [
      Colors.amber,
      Colors.blue[200]!,
      Colors.amberAccent,
      Colors.white,
    ];
    const colorizeTextStyle = TextStyle(
      fontSize: 38.0,
      fontFamily: 'LuckiestGuy',
    );
    //return RateRide();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
            child: Text(
              //'Ride Ready?',
              'Requesting Ride',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0)),
                  ),
                  child: SizedBox(
                    width: 250.0,
                    child: Center(
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText('Requesting Ride',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                              textAlign: TextAlign.center),
                          ColorizeAnimatedText('Please Wait',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                              textAlign: TextAlign.center),
                          ColorizeAnimatedText('Finding Cabby',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                              textAlign: TextAlign.center),
                        ],
                        isRepeatingAnimation: true,
                        repeatForever: true,
                        //onFinished: navigateToNextPage,
                      ),
                    ),
                  )),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.blue),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.navigation_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        //String url = '$baseUrl/$query.json?access_token=$accessToken';
                        String url =
                            'google.navigation:q=${destinationLocation.latitude!}, ${destinationLocation.longitude!}&key=$apiKey';
                        url = Uri.parse(url).toString();
                        print(url);
                        try {
                          _dio.options.contentType = Headers.jsonContentType;
                          //final responseData =
                          await _dio.get(url);
                          //return responseData.data;
                        } catch (e) {
                          final errorMessage =
                              DioExceptions.fromDioError(e as DioError)
                                  .toString();
                          debugPrint(errorMessage);
                          //return {}
                        }
                      },
                    ),
                  ),
                )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        cancelRide();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2.0, color: Colors.black54),
                          borderRadius: BorderRadius.circular(26.0),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 35.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
