// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/my_button.dart';
import '../Components/my_textfield.dart';
import '../Components/square_tile.dart';


class RegisterPage extends StatefulWidget {
  final Function()?onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        
      );
      } else {
        // show error message
        showErrorMessage("Passwords don't match");
      }
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
                const SizedBox(height: 20),
                //logo
                const Icon(
                  Icons.directions_car,
                  color: Colors.amber,
                  size: 90,
                ),
        
                const SizedBox(height: 25),
                
                //Log In
                Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontSize: 25,
                    ),
                  ),
                
                const SizedBox(height: 25),
        
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
                //confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
        
                
        
                const SizedBox(height: 20),
        
                //sign up button
                MyButton(
                  onTap: signUserUp ,
                  text: "Register",
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
                      child: const Text('Login now',
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