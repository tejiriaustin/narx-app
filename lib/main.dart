import 'package:flutter/material.dart';
import 'package:narx_app/pages/auth/forgot_password.dart';
import 'package:narx_app/pages/auth/sign_up.dart';
import 'package:narx_app/pages/auth/login.dart';
import 'package:narx_app/pages/dashboard/analytics.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Solarview",
      initialRoute: '/signup',
      routes: <String, WidgetBuilder>{
          "/signup": (context) => const SignupScreen(),
          "/login":  (context) => const LoginScreen(),
          "/forgot-password": (context) => const ForgotPasswordPage(),
          "/analytics": (context) => const AnalyticsPage(),
        },
    ),
  );
}