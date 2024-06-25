import 'package:flutter/material.dart';
import 'package:flutter_cab/Components/review_ride_fa_button.dart';
import 'package:flutter_cab/Components/endpoints_card.dart';

class PrepareRide extends StatefulWidget {
  const PrepareRide({super.key});

  @override
  State<PrepareRide> createState() => _PrepareRideState();

  //Declare a static function to reference setters from children
  static _PrepareRideState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PrepareRideState>();
}

class _PrepareRideState extends State<PrepareRide> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Flutter Cab',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              endpointsCard(sourceController, destinationController),
              // Linear progress indicator to show loading
              // Show an appropriate messahe if no address has been entered, or no results are found
              // Show a list view of results to select one from
            ],
          ),
        ),
      ),
      floatingActionButton: reviewRideFaButton(context),
    );
  }
}