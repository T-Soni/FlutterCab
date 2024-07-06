
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cab/Pages/login_or_register_page.dart';
import 'package:flutter_cab/Pages/user_home_page.dart';
import 'package:flutter_cab/Pages/driver_home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  void _showPopupAndNavigate(BuildContext context){
    showDialog( context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
     return AlertDialog(
      backgroundColor: Colors.grey[200],
      title: const Center(
        child: Text("Sorry",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        )),
      ),
      
      content: const Text("You do not have the required permissions.",
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      )),
     ); 
    },
   );

   Future.delayed(const Duration(seconds: 5), () {
    Navigator.of(context).pop(); //close the dialog
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const UserHomePage()),
      );
   });
  }

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
                  var isDriver = snapshot.data!['driver'];
                  if (isDriver == true) {
                    if(snapshot.data!['role']=='driver') {
                      return DriverHomePage();
                    } else {
                      // show the popup and navigate after 5s
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showPopupAndNavigate(context);
                      });
                      return Container();
                    }
                  } 
                  else if (isDriver == false) {
                    return const UserHomePage();
                  } 
                  else {
                    return const Center(
                      child: Text(
                        "Unknown role",
                        style: TextStyle(
                          fontSize: 18,
                        )));
                  }
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("User not found",
                          style: TextStyle(
                            fontSize: 18,
                          ),),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            ),
                          
                          child: const Text("Go to Login/Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
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
