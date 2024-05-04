import 'package:flutter/material.dart';

class PanelStatusScreen extends StatefulWidget {
  const PanelStatusScreen({super.key});

  @override
  State<PanelStatusScreen> createState() => _PanelStatusScreenState();
}

class _PanelStatusScreenState extends State<PanelStatusScreen> {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel Status"),
      ),
      body: const Center(
        child: Text("Panel Status"),
      ),
    );
  }
}