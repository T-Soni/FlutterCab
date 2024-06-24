//import 'dart:convert';

import 'package:flutter_cab/requests/mapbox_rev_geocoding.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

// Mapbox Reverse Geocoding
Future<Map> getParsedReverseGeocoding(LatLng latlng) async {
  var response = await getReverseGeocodingGivenLatLngUsingMapbox(latlng);
  if (response.isNotEmpty) {
    Map feature = response['features'][0];
    Map revGeocode = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': latlng
    };
    return revGeocode;
  } else {
    return {}; // handle empty response
  }
}
