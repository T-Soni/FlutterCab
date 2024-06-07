import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/login_page.dart';
import 'package:flutter_cab/Pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //initially show login page
  bool showLoginPage = true;
  String role = 'user'; //default role

  //toggle between login and register page
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  void setRole(String selectedRole) {
    setState(() {
      role = selectedRole;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            //Role selection buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => setRole('user'),
                    child: Text('User',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: role == 'user' ? Colors.amber : Colors.grey,
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => setRole('driver'),
                    child: Text('Driver',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: role == 'driver' ? Colors.amber : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: showLoginPage
                  ? LoginPage(
                    onTap: togglePages,
                    role: role,
                  )
                : RegisterPage(
                  onTap: togglePages,
                  role: role,
                ),
              )
          ],
        ),
      ),
    );
  }
}