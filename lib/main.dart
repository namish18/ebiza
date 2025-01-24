// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'signup_page.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/signup':
            return MaterialPageRoute(builder: (context) => const SignUpPage());
          case '/homepage':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/landing':
            return MaterialPageRoute(builder: (context) => const LandingPage());

          default:
            return MaterialPageRoute(builder: (context) => const LandingPage());
        }
      },
    );
  }
}
