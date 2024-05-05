import 'package:flutter/material.dart';


class ErrorMessage {
  final String message;
  final num statusCode;

  ErrorMessage({required this.message, required this.statusCode});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      message: json['message'],
      statusCode: json['statusCode'],
      );
  }
}
class ErrorDialog {
  const ErrorDialog(BuildContext context);
    
  showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    }
}
