import 'dart:async';

import 'package:flutter/material.dart';
import 'package:narx_app/api/firebase_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:narx_app/firebase_options.dart';

import 'package:narx_app/pages/auth/login.dart';
import 'package:narx_app/pages/auth/sign_up.dart';
import 'package:narx_app/pages/dashboard/dashboard.dart';
import 'package:narx_app/pages/auth/forgot_password.dart';


Future<void> main() async {
  final notificationManager = FirebaseApi();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await notificationManager.initNotifications();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  runApp(
    MaterialApp(
      title: "Solarview",
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        "/": (context) => const SplashScreen(),
        "/signup": (context) => const SignupScreen(),
        "/login": (context) => const LoginScreen(),
        "/dashboard": (context) => const DashboardScreen(),
        "/forgot-password": (context) => const ForgotPasswordScreen(),
      },
    ),
  );
}

// tejiriaustin123@gmail.com
// $password
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
