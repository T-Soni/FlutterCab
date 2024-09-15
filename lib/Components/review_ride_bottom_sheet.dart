import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/payment.dart';
import 'package:flutter_cab/Pages/request_ride.dart';
import 'package:flutter_cab/helpers/shared_prefs.dart';
import 'package:flutter_cab/main.dart';
import 'package:latlong2/latlong.dart';

class ReviewRideBottomSheet extends StatefulWidget {
  final String distance, dropOffTime, rate;
  final Map modifiedResponse;

  ReviewRideBottomSheet(
      {super.key,
      required this.distance,
      required this.dropOffTime,
      required this.rate,
      required this.modifiedResponse});

  @override
  State<ReviewRideBottomSheet> createState() => _ReviewRideBottomSheetState();
}

class _ReviewRideBottomSheetState extends State<ReviewRideBottomSheet> {
  // Get source and destination addresses from sharedPreferences

  String sourceAddress = getSourceAndDestinationPlaceText('source');
  String destinationAddress = getSourceAndDestinationPlaceText('destination');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String paymentMethod = "Cash";
  Widget paymentIcon = const Icon(
    Icons.currency_rupee,
    color: Colors.green,
  );

  Future<void> _uploadRideRequest() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic>? userData = userDoc.data();

          if (userData != null) {
            String sourceAddress =
                json.decode(sharedPreferences.getString('source')!)['place'];
            var sourceLocationData =
                json.decode(sharedPreferences.getString('source')!)['location']
                    as Map<String, dynamic>;
            List<dynamic> sourceCoordinates = sourceLocationData['coordinates'];
            LatLng sourceLoc = LatLng(
              sourceCoordinates[1],
              sourceCoordinates[0],
            );
            String destinationAddress = json
                .decode(sharedPreferences.getString('destination')!)['place'];
            var destinationLocationData = json.decode(
                    sharedPreferences.getString('destination')!)['location']
                as Map<String, dynamic>;
            List<dynamic> destinationCoordinates =
                destinationLocationData['coordinates'];
            LatLng destinationLoc = LatLng(
              destinationCoordinates[1],
              destinationCoordinates[0],
            );
            Map sourceLocation = {
              "lat": sourceLoc.latitude,
              "lng": sourceLoc.longitude,
            };
            Map destinationLocation = {
              "lat": destinationLoc.latitude,
              "lng": destinationLoc.longitude,
            };
            Map rideInfoMap = {
              "userId": user.uid,
              "driver_id": "waiting",
              "payment_method": "cash",
              "pickup": sourceLocation,
              "dropoff": destinationLocation,
              "created_at": DateTime.now().toString(),
              "rider_name": userData['name'] ?? 'Unknown',
              "rider_phone": userData['phone'] ?? 'Unknown',
              "pickup_address": sourceAddress,
              "dropOff_address": destinationAddress,
            };

            await _database.ref('ride_requests/${user.uid}').set(rideInfoMap);

            print('Ride details uploaded successfully!');
          }
        }
      }
    } catch (e) {
      print('Error uploading ride details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                Text(
                  '$sourceAddress ➡ $destinationAddress',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 130, 128, 128),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    leading: const Image(
                      image: AssetImage('images/car_android.png'),
                      height: 50,
                      width: 50,
                    ),
                    title: const Text(
                      'Trip',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${widget.distance} km, ${widget.dropOffTime} drop off',
                    ),
                    trailing: Text(
                      '₹${widget.rate}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                      tileColor: Colors.grey[200],
                      leading: paymentIcon,
                      title: Text(
                        paymentMethod,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text('choose payment options'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        Map finalPaymentMode = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PaymentScreen(),
                          ),
                        );

                        setState(() {
                          paymentMethod = finalPaymentMode["paymentMethod"];
                          paymentIcon = finalPaymentMode["paymentIcon"];
                        });
                      }),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _uploadRideRequest();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RequestRide(
                            modifiedResponse: widget.modifiedResponse,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      padding: const EdgeInsets.all(15),
                    ),
                    child: Text(
                      'Request Ride',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
