import 'package:flutter/material.dart';


class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {

          },
           child: const Text('Go back!'),
           )
      ),

    );
  }
  
}