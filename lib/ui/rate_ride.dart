import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/user_home_page.dart';
//import 'package:flutter_cab/helpers/shared_prefs.dart';
import 'package:flutter_cab/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateRide extends StatelessWidget {
  RateRide({super.key});

  final String sourceAddress =
      json.decode(sharedPreferences.getString('source')!)['place'];
  final String destinationAddress =
      json.decode(sharedPreferences.getString('destination')!)['place'];

  _saveTripHistory(var rating) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Trip History')
        .add({
      'destination': destinationAddress,
      'source': sourceAddress,
      'rating': rating
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('Rate your ride', style: Theme.of(context).textTheme.titleLarge),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
              _saveTripHistory(rating);
            },
          ),
        ),
      ),
      ElevatedButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const UserHomePage())),
          child: const Text('Start another ride'))
    ]));
  }
}
