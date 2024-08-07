import 'package:flutter/material.dart';
import 'package:flutter_cab/Components/location_fiels.dart';

Widget endpointsCard(TextEditingController sourceController,
    TextEditingController destinationController) {
  return Card(
      color: Colors.grey[100],
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(0),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Column(
              children: [
                const Icon(Icons.brightness_1, size: 8),
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  color: Colors.black,
                  width: 1,
                  height: 40,
                ),
                const Icon(Icons.stop, size: 12),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  LocationField(
                      isDestination: false,
                      textEditingController: sourceController),
                  LocationField(
                    isDestination: true,
                    textEditingController: destinationController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}
