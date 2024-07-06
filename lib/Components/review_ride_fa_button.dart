import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../helpers/mapbox_handler.dart';
import '../helpers/shared_prefs.dart';
import '../Pages/review_ride.dart';

Widget reviewRideFaButton(BuildContext context) {
  return FloatingActionButton.extended(
      icon: const Icon(Icons.local_taxi),
      onPressed: () async {
        LatLng sourceLatLng = getTripLatLngFromSharedPrefs('source');
        LatLng destinationLatLng = getTripLatLngFromSharedPrefs('destination');
        print('sourceLatLng: ${sourceLatLng}');
        print('destinationLatLng: ${destinationLatLng}');

        Map modifiedResponse =
            await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);
        print('response from directions api: ${modifiedResponse}');
        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ReviewRide(modifiedResponse: modifiedResponse)));
        }
      },
      label: const Text('Review Ride'));
}
