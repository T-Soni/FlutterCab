
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cab/Pages/login_or_register_page.dart';
import 'package:flutter_cab/Pages/user_home_page.dart';
import 'package:flutter_cab/Pages/driver_home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator()
              );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong")
              );
          } else if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator()
                    );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong")
                    );
                } else if (snapshot.hasData && snapshot.data!.exists) {
                  var userRole = snapshot.data!['role'];
                  if (userRole == 'user') {
                    return UserHomePage();
                  } 
                  else if (userRole == 'driver') {
                    return DriverHomePage();
                  } 
                  else {
                    return const Center(child: Text("Unknown role"));
                  }
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("User not found"),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          child: const Text("Go to Login/Register"),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
