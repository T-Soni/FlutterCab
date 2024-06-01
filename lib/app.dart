import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/auth_page.dart';
//import 'auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // theme: ThemeData(
      //   primarySwatch: Colors.amber,
      // ),
      // home: const AuthGate(),
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
