import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/login_page.dart';
//import 'auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   primarySwatch: Colors.amber,
      // ),
      // home: const AuthGate(),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
