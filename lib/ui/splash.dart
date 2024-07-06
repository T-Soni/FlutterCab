import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/auth_page.dart';
import 'package:flutter_cab/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../helpers/mapbox_handler.dart';
import 'package:flutter/cupertino.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  void initializeLocationAndSave() async {
    //Ensure all permissions are collected for locations

    bool? serviceEnabled;

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServicesDialog();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position locationData = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng currentLocation =
        LatLng(locationData.latitude, locationData.longitude);

    // Get the current user address
    String currentAddress =
        (await getParsedReverseGeocoding(currentLocation))['place'];

    //Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', locationData.latitude);
    sharedPreferences.setDouble('longitude', locationData.longitude);
    sharedPreferences.setString('current-address', currentAddress);

    Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
        (route) => false);
  }

  void _showLocationServicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
            'Please enable location services to continue using this app'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                initializeLocationAndSave();
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.amber,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          CupertinoIcons.car_detailed,
          color: Colors.black,
          size: 120,
        ),
        Text(
          'Flutter Cab',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    );
  }
}
