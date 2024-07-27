import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/prepare_ride.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../helpers/mapbox_handler.dart';
import '../helpers/shared_prefs.dart';
import '../main.dart';

class LocationField extends StatefulWidget {
  final bool isDestination;
  final TextEditingController textEditingController;

  const LocationField({
    super.key,
    required this.isDestination,
    required this.textEditingController,
  });

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  Timer? searchOnStoppedTyping;
  String query = '';
  bool isFavorite = false;
  var favoriteDestinationId;

  String destination = '';

  _onChangeHandler(value) {
    // Set isLoading = true in parent
    PrepareRide.of(context)?.isLoading = true;

    // Make sure that requests are not made until 1 second after the typing stops
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() => searchOnStoppedTyping =
        Timer(const Duration(seconds: 1), () => _searchHandler(value)));
  }

  _searchHandler(String value) async {
    // Get response using Mapbox Search API
    List response = await getParsedResponseForQuery(value);

    //store the source and destination in shared preferences
    if (widget.isDestination) {
      sharedPreferences.setString('destination', json.encode(response));
    } else {
      sharedPreferences.setString('source', json.encode(response));
    }

    // Set responses and isDestination in parent

    PrepareRide.of(context)?.responsesState = response;
    PrepareRide.of(context)?.isResponseForDestinationState =
        widget.isDestination;
    setState(() => query = value);
    //PrepareRide.of(context)?.isFavoriteDestination = isFavorite;
  }

  _useCurrentLocationButtonHandler() async {
    if (!widget.isDestination) {
      LatLng currentLocation = getCurrentLatLngFromSharedPrefs();

      // Get the response of reverse geocoding and...
      // 1. Store encoded response in shared preferences
      // 2. Set the text editing controller to the address
      var response = await getParsedReverseGeocoding(currentLocation);
      print('source location: ${response['location']}');
      sharedPreferences.setString('source', json.encode(response));
      String place = response['place'];
      print(response['location']);
      widget.textEditingController.text = place;
    }
  }

  _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });
    if (isFavorite) {
      var docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('favorites')
          .add({'destination': sharedPreferences.getString('destination')});
      // .add({'destination': widget.textEditingController.text});
      favoriteDestinationId = docRef.id;
    } else {
      if (favoriteDestinationId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('favorites')
            .doc(favoriteDestinationId)
            .delete();
        favoriteDestinationId = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String placeholderText = widget.isDestination ? 'Where to?' : 'Where from?';
    IconData iconData = !widget.isDestination
        ? Icons.my_location
        : isFavorite
            ? Icons.favorite
            : Icons.favorite_border;
    Color iconColor = isFavorite ? Colors.red : Colors.black;
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      child: CupertinoTextField(
          controller: widget.textEditingController,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          placeholder: placeholderText,
          placeholderStyle: GoogleFonts.rubik(color: Colors.indigo[300]),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            color: Colors.grey[100],
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          onChanged: _onChangeHandler,
          suffix: IconButton(
              onPressed: () => widget.isDestination
                  ? _toggleFavorite()
                  : _useCurrentLocationButtonHandler(),
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(),
              icon: Icon(iconData, size: 20, color: iconColor))),
    );
  }
}
