import 'package:flutter/material.dart';
import 'package:narx_app/pages/auth/sign_up.dart';
import 'package:narx_app/utils/const.dart';
import 'package:narx_app/pages/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      initialRoute: '/',
      routes: {
        "/login":  (context) => const LoginPage(),
        "/signup": (context) => const SignupPage(),
      },
    );
  }
}
