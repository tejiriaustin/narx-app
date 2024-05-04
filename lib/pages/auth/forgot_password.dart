import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narx_app/utils/const.dart';
import 'package:http/http.dart' as http;

var backendUrl = "https://narx-api.onrender.com/v1";

Future<Null> login(String email) async {
  final http.Response response = await http.post(
    Uri.parse('$backendUrl/forgot-password'),
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

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
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
          onPressed: () {
          
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
      child: const Text("Login", style: TextStyle(color: Colors.blue)),
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
            child: const Text("Sign Up", style: TextStyle(color: Colors.blue),)
        )
      ],
    );
  }
}