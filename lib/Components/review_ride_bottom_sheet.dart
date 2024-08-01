import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/payment.dart';
import 'package:flutter_cab/Pages/turn_by_turn.dart';
import 'package:flutter_cab/helpers/shared_prefs.dart';

class ReviewRideBottomSheet extends StatefulWidget {
  final String distance, dropOffTime, rate;
  const ReviewRideBottomSheet(
      {super.key,
      required this.distance,
      required this.dropOffTime,
      required this.rate});

  @override
  State<ReviewRideBottomSheet> createState() => _ReviewRideBottomSheetState();
}

class _ReviewRideBottomSheetState extends State<ReviewRideBottomSheet> {
  // Get source and destination addresses from sharedPreferences

  String sourceAddress = getSourceAndDestinationPlaceText('source');
  String destinationAddress = getSourceAndDestinationPlaceText('destination');

  String paymentMethod = "Cash";
  Widget paymentIcon = const Icon(
    Icons.currency_rupee,
    color: Colors.green,
  );

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
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TurnByTurn(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    padding: const EdgeInsets.all(15),
                  ),
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
                    ],
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
