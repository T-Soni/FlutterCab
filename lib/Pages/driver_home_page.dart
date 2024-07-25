import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverHomePage extends StatelessWidget {
  DriverHomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Flutter Cab',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
          child: Text(
        "Driver logged in as: ${user.email!}",
        style: const TextStyle(fontSize: 20),
      )),
    );
  }
}
