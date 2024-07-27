import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<String> userEmail;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                user.email!,
                style: const TextStyle(fontSize: 20),
              ),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                        backgroundImage: AssetImage('images/user_icon.png')),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
