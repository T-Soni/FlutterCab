import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/helpers/shared_prefs.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class DriverHomePage extends StatefulWidget {
  DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
  late String currentAddress;
  late CameraOptions _initialCameraPosition;

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
    currentAddress = getCurrentAddressFromSharedPrefs();
  }

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Flutter Cab',
          style: TextStyle(
            color: Colors.black,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Stack(
        children: [
          // Mapbox Map added here and user location enabled
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
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Pick up your next ride?',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text('You are currently here:'),
                      Text(
                        currentAddress,
                        style: const TextStyle(color: Colors.indigo),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        // onPressed: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => const PrepareRide())),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.amberAccent),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Check drive requests near you',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
