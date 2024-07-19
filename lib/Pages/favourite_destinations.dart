//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/main.dart';

class FavoriteDestinationsList extends StatefulWidget {
  final List<DocumentSnapshot> favoriteDestinationsList;
  final TextEditingController destinationController;
  final TextEditingController sourceController;
  final bool isResponseForDestination;
  const FavoriteDestinationsList(
      {super.key,
      required this.favoriteDestinationsList,
      required this.isResponseForDestination,
      required this.destinationController,
      required this.sourceController});

  @override
  State<FavoriteDestinationsList> createState() =>
      FavoriteDestinationsListState();
}

class FavoriteDestinationsListState extends State<FavoriteDestinationsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Favourite Destinations',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.amber,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: widget.favoriteDestinationsList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      String text =
                          widget.favoriteDestinationsList[index]['destination'];
                      //if (widget.isResponseForDestination) {
                      widget.destinationController.text = text;
                      sharedPreferences.setString('destinatioon', text);
                      //} else {
                      //widget.sourceController.text = text;
                      //sharedPreferences.setString('source', text);
                      //}
                      Navigator.pop(context);
                    },
                    leading: const SizedBox(
                      height: double.infinity,
                      child: CircleAvatar(
                        backgroundColor: Colors.amberAccent,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    title: Text(
                      '${widget.favoriteDestinationsList[index]['destination']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    //subtitle: Text(' '),
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ));
  }
}
