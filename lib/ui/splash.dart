import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/auth_page.dart';
import 'package:flutter_cab/main.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
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
  Location location = Location();
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if(!serviceEnabled){
    serviceEnabled = (await location.requestService()) as bool?;
  }

  permissionGranted = await location.hasPermission();
  if(permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
  }

  // Get the current user location
  LocationData locationData = await location.getLocation();
  LatLng currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

  // Get the current user address
  String currentAddress = (await getParsedReverseGeocoding(currentLocation))['place'];

  //Store the user location in sharedPreferences
  sharedPreferences.setDouble('latitude', locationData.latitude!);
  sharedPreferences.setDouble('longitude', locationData.longitude!);
  sharedPreferences.setString('current-address', currentAddress);

  Navigator.pushAndRemoveUntil(
    // ignore: use_build_context_synchronously
    context,
    MaterialPageRoute(builder: (_) => const AuthPage()),
    (route) => false
  );
}

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
        ]
      ),
    );
  }
}