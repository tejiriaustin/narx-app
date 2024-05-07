import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:narx_app/services/auth.dart';
import 'package:narx_app/utils/const.dart';
import 'package:narx_app/view_models/account.dart';
import 'package:narx_app/widgets/dialog.dart';

var backendUrl = "https://narx-api.onrender.com/v1";

Future<Account> login(String email, String password) async {
  final http.Response response = await http.post(
    Uri.parse('$backendUrl/user/login'),
    headers: <String, String>{
	    'Content-Type': 'application/json; charset=UTF-8',
	  },
	  body: jsonEncode(<String, String>{
	    'email': email,
      'password': password
	}),
  );

  if (response.statusCode == 200) {
	  return Account.fromJson(json.decode(response.body));
  } else {
	  throw Exception(response.body);
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            _inputField(context),
            _forgotPassword(context),
            _signup(context),
          ],
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
          controller: emailController,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
                  ),
              fillColor: Constants.defaultGrey.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Constants.defaultGrey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: isLoading ? null : () async {
            setState(() {
              isLoading = true;
            });

            String errorMessage = '';
            try {
              Account account = await login(emailController.text.toString(), passwordController.text.toString());
              if (account.token != '') {
                print(account.token);
                AuthService.saveAuthToken(account.token);
                if (context.mounted) Navigator.pushNamed(context, '/dashboard');
              }
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(width: 7),
              ],
              const Text(
                "Login",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          )
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/forgot-password');
      },
      child: const Text("Forgot password?",
        style: TextStyle(color: Colors.green),
      ),
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