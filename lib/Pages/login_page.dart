// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/forgot_password_page.dart';
import 'package:flutter_cab/services/auth_service.dart';
import '../Components/my_button.dart';
import '../Components/my_textfield.dart';
import '../Components/square_tile.dart';


class LoginPage extends StatefulWidget {
  final Function()?onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
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
      body: 
         SafeArea(
          child: Center(
            child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                //logo
                const Icon(
                  Icons.directions_car,
                  color: Colors.amber,
                  size: 100,
                ),
        
                const SizedBox(height: 30),
                
                //Log In
                Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontSize: 25,
                    ),
                  ),
                
                const SizedBox(height: 30),
        
                //username textfield
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
        
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ForgotPasswordPage();
                            },
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                          ),
                      ),
                    ],
                  ),
                ),
        
                const SizedBox(height: 20),
        
                //sign in button
                MyButton(
                  onTap: signUserIn ,
                  text: "Log In",
                ),
        
                const SizedBox(height: 30),
                
                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
            
                const SizedBox(height: 25),

                //google sign in button
                Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/Images/google_logo.png'),
                  ]
                ),

                const SizedBox(height: 10),
            
                //not a user? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a User?  ',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                      ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register now',
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
      )
    );
  }
}