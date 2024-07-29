// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/services/auth_service.dart';

import '../Components/my_button.dart';
import '../Components/my_textfield.dart';
import '../Components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  final String role;
  const RegisterPage({super.key, required this.onTap, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating the user
    try {
      //check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        //saving the user role in firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'name': nameController.text,
          'email': emailController.text,
          'role': 'user',
          'driver': widget.role == 'driver' ? true : false,
        });

        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        // show error message
        showErrorMessage("Passwords don't match");
      }
      // pop the loading circle
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      //show error message
      showErrorMessage(e.code);
    }
  }

  // error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Icon(
                    Icons.directions_car,
                    color: Colors.amber,
                    size: 80,
                  ),

                  const SizedBox(height: 5),

                  //Register
                  Text(
                    'Register as ${widget.role == 'user' ? 'User' : 'Driver'}',
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontSize: 25,
                    ),
                  ),

                  const SizedBox(height: 15),

                  //username textfield
                  MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                  ),

                  const SizedBox(height: 15),

                  //email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),
                  //password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),
                  //confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  //sign up button
                  MyButton(
                    onTap: signUserUp,
                    text: "Register",
                  ),

                  const SizedBox(height: 10),

                  //or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'or continue with',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  //google sign in button
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    // google button
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'lib/Images/google_logo.png'),
                  ]),

                  const SizedBox(height: 5),

                  //already a user? login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?  ',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
