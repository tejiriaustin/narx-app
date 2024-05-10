import 'package:flutter/material.dart';
import 'package:narx_app/view_models/sensors.dart';


class AnalyticsPage extends StatefulWidget {
  final Sensor sensor;

  const AnalyticsPage({super.key, required this.sensor});

  @override
  AnalyticsPageState createState() => AnalyticsPageState();
}

class AnalyticsPageState extends State<AnalyticsPage> {
  
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