import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/helpers/shared_prefs.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ActiveRidesPage extends StatefulWidget {
  const ActiveRidesPage({super.key});

  @override
  State<ActiveRidesPage> createState() => _ActiveRidesPageState();
}

class _ActiveRidesPageState extends State<ActiveRidesPage> {
  final List<CameraOptions> _kTripEndPoints = [];
  late MapboxMap mapboxMapController;
  late CameraOptions _initialCameraPosition;
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;

  PolylineAnnotation? polylineAnnotation;
  PolylineAnnotationManager? polylineAnnotationManager;
  final user = FirebaseAuth.instance.currentUser!;
  LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
  late String currentAddress;
  late double driverLat;
  late double driverLng;

  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('ride_requests');
  List<Map<String, dynamic>> nearbyRequests = [];

  List<Map<String, dynamic>> userLocations = [];

  @override
  void initState() {
    super.initState();

    // Set initial camera position and current address
    _initialCameraPosition = CameraOptions(
      center: Point(
        coordinates: Position(
          currentLocation.longitude,
          currentLocation.latitude,
        ),
      ),
      zoom: 14,
    );
    driverLng = currentLocation.longitude;
    driverLat = currentLocation.latitude;
    currentAddress = getCurrentAddressFromSharedPrefs();
    fetchAndFilterRideRequests(10000);
  }

  Future<void> fetchAndFilterRideRequests(double maxDistanceInKm) async {
    try {
      _databaseReference.onValue.listen((DatabaseEvent event) async {
        final snapshot = await event.snapshot;
        if (snapshot.exists) {
          nearbyRequests.clear(); // to clear previous requests
          final Map<dynamic, dynamic> data =
              snapshot.value as Map<dynamic, dynamic>;
          if (data.isNotEmpty) {
            data.forEach((key, value) {
              Map<String, dynamic> rideDetails =
                  Map<String, dynamic>.from(value);
              if (rideDetails.containsKey('pickup')) {
                double userLat = rideDetails['pickup']['lat'].toDouble();
                double userLng = rideDetails['pickup']['lng'].toDouble();
                double distance = Geolocator.distanceBetween(
                        driverLat, driverLng, userLat, userLng) /
                    1000;
                if (distance <= maxDistanceInKm) {
                  nearbyRequests.add(rideDetails);
                  // Add camera options for each request
                  CameraOptions _cameraOptions = CameraOptions(
                    center: Point(
                      coordinates: Position(
                        userLng,
                        userLat,
                      ),
                    ),
                    zoom: 14,
                  );
                  _kTripEndPoints.add(_cameraOptions);
                }
              }
            });
            print('Nearby requests: $nearbyRequests');
            // Update the map after fetching requests
            if (mapboxMapController != null && pointAnnotationManager != null) {
              await _addPointsToMap();
            }
          } else {
            print('data is null');
          }
        } else {
          print('snapshot does not exist');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addPointsToMap() async {
    if (_kTripEndPoints.isNotEmpty) {
      final ByteData squareImageData =
          await rootBundle.load('images/square.png');
      final Uint8List square = squareImageData.buffer.asUint8List();

      var options = <PointAnnotationOptions>[];
      for (var i = 0; i < _kTripEndPoints.length; i++) {
        options.add(PointAnnotationOptions(
          geometry: _kTripEndPoints[i].center as Point,
          image: square,
          iconSize: 0.1,
        ));
      }
      if (options.isNotEmpty) {
        await pointAnnotationManager!.createMulti(options);
        print('Point annotations created');
      } else {
        print('No point annotations to create');
      }
    }
  }

  _onMapCreated(MapboxMap mapboxMapController) async {
    this.mapboxMapController = mapboxMapController;

    mapboxMapController.annotations
        .createPointAnnotationManager()
        .then((pointAnnotationManager) async {
      this.pointAnnotationManager = pointAnnotationManager;
      await _addPointsToMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 28, 0),
            child: Text(
              'Active Ride Requests',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: [
          // Mapbox Map added here
          MapWidget(
            key: const ValueKey("mapWidget"),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            cameraOptions: _initialCameraPosition,
            onMapCreated: (MapboxMap mapboxMap) {
              // Enable user location
              mapboxMap.location.updateSettings(LocationComponentSettings(
                enabled: true,
                pulsingEnabled: true,
              ));
              _onMapCreated(mapboxMap);
            },
            mapOptions: MapOptions(
              contextMode: ContextMode.UNIQUE,
              constrainMode: ConstrainMode.HEIGHT_ONLY,
              viewportMode: ViewportMode.DEFAULT,
              orientation: NorthOrientation.UPWARDS,
              crossSourceCollisions: true,
              pixelRatio: MediaQuery.of(context).devicePixelRatio,
            ),
          ),
        ],
      ),
    );
  }
}
