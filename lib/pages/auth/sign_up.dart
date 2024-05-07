import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:narx_app/view_models/account.dart';
import 'package:narx_app/services/auth.dart';
import 'package:narx_app/widgets/dialog.dart';


final defaultColor = Colors.grey.withOpacity(0.1);

var backendUrl = "https://narx-api.onrender.com/v1";

Future<Account> signup(String email, String password, String firstName, String lastName) async {
  final http.Response response = await http.post(
    Uri.parse('$backendUrl/user/sign-up'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    }),
  );

  if (response.statusCode == 200) {
	  return Account.fromJson(json.decode(response.body));
  } else {
	  throw Exception(response.body);
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}
class _SignupScreenState extends State<SignupScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController= TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),

                  const Text("Sign up",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text("Create your account",style: TextStyle(fontSize: 15, color: Colors.grey[700]))
                ],
              ),
              Column(
                children: <Widget>[

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                              hintText: "First Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: defaultColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.person)),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                              hintText: "Last Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: defaultColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.person)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: defaultColor,
                        filled: true,
                        prefixIcon: const Icon(Icons.email)),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: defaultColor,
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                    ),
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                          fillColor: defaultColor,
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () async {
                      setState(() {
                        isLoading = true;
                      });
                      String errorMessage = '';

                      try {
                        Account account = await signup(emailController.text.toString(), passwordController.text.toString(), firstNameController.text.toString(), lastNameController.text.toString());
                        if (account.token != '') {
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
                      if (errorMessage.isNotEmpty && context.mounted && Navigator.canPop(context)) showErrorDialog(context, errorMessage);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading) ...[
                          const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(width: 10),
                        ],
                        const Text(
                          "Sign up",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    )
                  )
              ),

              const Center(child: Text("Or")),

              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.green,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 18),

                      const Text("Sign In with Google",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Text("Login", style: TextStyle(color: Colors.green))
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}