import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/payment.dart';
import 'package:flutter_cab/Pages/turn_by_turn.dart';
import 'package:flutter_cab/helpers/shared_prefs.dart';

Widget reviewRideBottomSheet(
    BuildContext context, String distance, String dropOffTime, String rate) {
  // Get source and destination addresses from sharedPreferences
  String sourceAddress = getSourceAndDestinationPlaceText('source');
  String destinationAddress = getSourceAndDestinationPlaceText('destination');

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
                      Text('$sourceAddress ➡ $destinationAddress',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 130, 128, 128),
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            tileColor: Colors.grey[200],
                            leading: const Image(
                                image: AssetImage('images/car_android.png'),
                                height: 50,
                                width: 50),
                            title: const Text(
                              'Trip',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                Text('$distance km, $dropOffTime drop off'),
                            trailing: Text(
                              '₹$rate',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            tileColor: Colors.grey[200],
                            // leading: const Image(
                            //     image: AssetImage('images/car_android.png'),
                            //     height: 50,
                            //     width: 50),
                            leading: const Icon(
                              Icons.currency_rupee,
                              color: Colors.green,
                            ),
                            title: const Text(
                              'Cash',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: const Text('choose payment options'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const PaymentScreen())),
                          )),
                      ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const TurnByTurn())),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              padding: const EdgeInsets.all(15)),
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Start your ride now',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ]))
                    ]),
              ))));
}
