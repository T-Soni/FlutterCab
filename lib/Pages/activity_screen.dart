import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<DocumentSnapshot> tripHistoryList = [];

  @override
  void initState() {
    super.initState();
    getTripHistory();
  }

  getTripHistory() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Trip History')
        .get();
    setState(() {
      tripHistoryList = snap.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Activity',
          style: TextStyle(
            fontSize: 35,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Trip History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              //reverse: true,
              itemCount: tripHistoryList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 35,
                            child: CircleAvatar(
                              backgroundColor: Colors.amberAccent,
                              child: Icon(
                                Icons.history,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      tripHistoryList[index]['source'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16),
                                      maxLines: 3,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      tripHistoryList[index]['destination'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  tripHistoryList[index]['tripTime'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                          child: RatingBarIndicator(
                            rating: tripHistoryList[index]['rating'],
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.vertical,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
