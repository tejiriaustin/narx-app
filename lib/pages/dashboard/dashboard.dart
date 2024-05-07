import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:narx_app/view_models/requests.dart';
import 'package:narx_app/view_models/sensors.dart';
import 'package:narx_app/widgets/dialog.dart';

var backendUrl = "https://narx-api.onrender.com/v1";

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Sensor> sensors = []; // List to store fetched systems
  String selectedSensor = '';

  Future<void> fetchSolarSystems(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken'); // Read token from SharedPreferences
    Message message;

    if (authToken == null) {
      // Handle missing auth token (e.g., prompt user to login)
      Navigator.of(context).pushNamed('/login');
      return;
    }

    final response = await http.get(
      Uri.parse('$backendUrl/sensors/list'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json; charset=UTF-8',
        },
    );

    ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));

    if (response.statusCode == 200) {
      sensors = Sensor.fromJsonArray(apiResponse.body.records);
      setState(() {});
    } else {
      // Handle error scenario
      print(apiResponse.message);
      showErrorDialog(context, apiResponse.message);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSolarSystems(context); // Fetch data on widget initialization
  }

   void navigateToAddSensorModal() {

     Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddSensorModal()),
  ).then((value) {
    if (value != null) { // Check if data was returned (indicating successful submit)
      // Reload data here (e.g., call fetchSolarSystems again)
    }
  });
    showModalBottomSheet(
      context: context,
      builder: (context) => const AddSensorModal(),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Sensors',
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose a solar system you would like to track',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            sensors.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: sensors.map((system) => buildSystemOption(system)).toList(),
                  ),
            const SizedBox(height: 20.0), // Add spacing between list and button
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: navigateToAddSensorModal,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildSystemOption(Sensor sensor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSensor = sensor.name;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedSensor == sensor.name ? Colors.green[200] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          sensor.name,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}


class AddSensorModal extends StatefulWidget {
  const AddSensorModal({super.key});

  @override
  AddSensorModalState createState() => AddSensorModalState();
}

class AddSensorModalState extends State<AddSensorModal> {
  String sensorName = '';
  String ipAddress = '';

  void submitSensor() async {

  final prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('authToken'); 

  final http.Response response = await http.post(
    Uri.parse('$backendUrl/sensors/add'),
    headers: <String, String>{
	    'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $authToken'
	  },
	  body: jsonEncode(<String, String>{
	    'ipAddress': ipAddress,
      'name': sensorName
	}),
  );

  if (response.statusCode == 200) {
	  Navigator.pop(context); // Close the modal
  } else {
	  throw Exception(response.body);
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Content adjusts to fit
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Sensor Name',
            ),
            onChanged: (value) => setState(() => sensorName = value),
          ),
          const SizedBox(height: 10.0),
          TextField(
            decoration: const InputDecoration(
              labelText: 'IP Address',
            ),
            onChanged: (value) => setState(() => ipAddress = value),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close the modal
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: sensorName.isNotEmpty && ipAddress.isNotEmpty
                    ? submitSensor
                    : null, // Disable submit if any field is empty
                child: const Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
