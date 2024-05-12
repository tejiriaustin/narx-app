import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:narx_app/widgets/dialog.dart';
import 'package:narx_app/constants/const.dart';


var backendUrl = "https://narx-api.onrender.com/v1";

Future<Null> forgotPassword(String email) async {
  final http.Response response = await http.post(
    Uri.parse('$backendUrl/user/forgot-password'),
    headers: <String, String>{
	    'Content-Type': 'application/json; charset=UTF-8',
	  },
	  body: jsonEncode(<String, String>{
	    'email': email,
	}),
  );
  if (response.statusCode == 200) {
  } else {
	    throw Exception(response.body);
}
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _login(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Forgot Your Password",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your email address", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
                  ),
              fillColor: Constants.defaultBaseAppColor.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : () async {
            setState(() {
              isLoading = true;
            });
            String errorMessage = '';

            try {
              await forgotPassword(emailController.text.toString());
              Navigator.of(context).pushNamed('/dashboard');
            } catch (e) {
                errorMessage = e.toString();
            }
            setState(() {
              isLoading = false;
            });
            // Show error dialog
            if (errorMessage.isNotEmpty && Navigator.canPop(context)) {
              showErrorDialog(context, errorMessage);
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Constants.defaultBaseAppColor,
          ),
          child: const Text(
            "Send Email",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  _login(context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      child: const Text("Login", style: TextStyle(color: Colors.green)),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
            onPressed: () {
               Navigator.pushNamed(context, '/signup');
             },
            child: const Text("Sign Up", style: TextStyle(color: Colors.green),)
        )
      ],
    );
  }
}