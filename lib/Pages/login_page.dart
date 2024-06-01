import 'package:flutter/material.dart';
import '../Components/my_button.dart';
import '../Components/my_textfield.dart';
import '../Components/square_tile.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
   signUserIn(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
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
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                ),
        
                const SizedBox(height: 25),
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
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
        
                const SizedBox(height: 20),
        
                //sign in button
                MyButton(
                  onTap:signUserIn() ,
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
                const Row(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'lib/images/google_logo.png'),
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
                    const Text('Register now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
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

