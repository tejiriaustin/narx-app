import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:narx_app/pages/auth/login.dart';
import 'package:narx_app/pages/auth/sign_up.dart';


void main() {
  runApp(
    MaterialApp(
      title: "Solarview",
      initialRoute: '/',
      routes: {
          "/": (context) => const SplashScreen(),
          "/signup": (context) => const SignupScreen(),
          "/login": (context) => const LoginScreen(),
        },
    ),
  );
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignupScreen()));
    }
  }
  
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () { 
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/icon.png',
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 5),
            const Text(
              'Solarview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
