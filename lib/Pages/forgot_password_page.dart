import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/Components/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context, 
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link set! Check your email'),
          );
        },
       );
    }on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text('Enter your email and we will send you a password reset link',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 16,
                            ),
                            ),
              ),
            const SizedBox(height: 10),
            Padding(
              padding:const EdgeInsets.symmetric(horizontal: 25.0),
              child: MyTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      obscureText: false,
                  ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: passwordReset,
              color: Colors.amber[600],
              child: const Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  ),),
            ),
            ]
          ),
          ),
          ),
    );
  }
}