import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/Components/endpoints_card.dart';
import 'package:flutter_cab/Components/review_ride_fa_button.dart';
import 'package:flutter_cab/Components/search_listview.dart';
import 'package:flutter_cab/Pages/favourite_destinations.dart';

class PrepareRide extends StatefulWidget {
  const PrepareRide({super.key});

  @override
  State<PrepareRide> createState() => PrepareRideState();

  // Declare a static function to reference setters from children
  static PrepareRideState? of(BuildContext context) =>
      context.findAncestorStateOfType<PrepareRideState>();
}

class PrepareRideState extends State<PrepareRide> {
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  bool isResponseForDestination = false;

  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';

  List responses = [];

  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  // Define setters to be used by children widgets
  set responsesState(List responses) {
    setState(() {
      this.responses = responses;
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() {
        isLoading = false;
      }),
    );
  }

  set isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  set isResponseForDestinationState(bool isResponseForDestination) {
    setState(() {
      this.isResponseForDestination = isResponseForDestination;
    });
  }

  bool isFirstTime = false;
  List<DocumentSnapshot> favoriteDestinationsList = [];

  getFavoriteDestinations() async {
    if (!isFirstTime) {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('favorites')
          .get();
      isFirstTime = true;
      setState(() {
        favoriteDestinationsList.addAll(snap.docs);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    isFirstTime = false;
  }

  @override
  Widget build(BuildContext context) {
    getFavoriteDestinations();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Flutter Cab',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
                backgroundImage: AssetImage('images/user_icon.png')),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              endpointsCard(sourceController, destinationController),
              isLoading
                  ? const LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : Container(),
              isEmptyResponse
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                            child: Text(
                              hasResponded ? noResponse : noRequest,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          ListTile(
                            onTap: () async {
                              getFavoriteDestinations();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => FavoriteDestinationsList(
                                            favoriteDestinationsList:
                                                favoriteDestinationsList,
                                            isResponseForDestination:
                                                isResponseForDestination,
                                            destinationController:
                                                destinationController,
                                            sourceController: sourceController,
                                          )));
                            },
                            leading: const SizedBox(
                              height: double.infinity,
                              child: CircleAvatar(
                                  backgroundColor: Colors.amberAccent,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.black,
                                  )),
                            ),
                            title: const Text('Favourite Destinations',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          //const Divider(),
                        ],
                      )))
                  : Container(),
              searchListView(responses, isResponseForDestination,
                  destinationController, sourceController),
            ],
          ),
        ),
      ),
      floatingActionButton: reviewRideFaButton(context),
    );
  }
}
