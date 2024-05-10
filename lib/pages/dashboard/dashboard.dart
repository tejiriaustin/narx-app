import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:narx_app/view_models/requests.dart';
import 'package:narx_app/view_models/sensors.dart';
import 'package:narx_app/widgets/dialog.dart';
import 'package:narx_app/pages/dashboard/analytics.dart';

var backendUrl = "https://narx-api.onrender.com/v1";

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Sensor> sensors = []; // List to store fetched systems
  String selectedSensor = '';
  bool isLoading = false; // Flag to indicate data fetching state
  List<Sensor> sensorState = []; // List to store fetched systems


  Future<void> fetchSolarSystems(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken'); // Read token from SharedPreferences

    if (authToken == null) {
      // Handle missing auth token (e.g., prompt user to login)
      Navigator.of(context).pushNamed('/login');
      return;
    }

    setState(() {
      isLoading = true; // Set loading state to true
    });

    final response = await http.get(
      Uri.parse('$backendUrl/sensors/list'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json; charset=UTF-8',
        },
    );

    ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));

    setState(() {
      isLoading = false; // Set loading state to false after response
    });

    if (response.statusCode == 200) {
      sensors = Sensor.fromJsonArray(apiResponse.body.records);
      setState(() {
        sensorState = sensors;
      });
    } else {
      // Handle error scenario
      showErrorDialog(context, apiResponse.message);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSolarSystems(context); // Fetch data on widget initialization
  }

  void navigateToAddSensorModal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSensorModal()),
    );

    if (result != null) {
      // Handle successful submit (e.g., reload data)
      fetchSolarSystems(context);
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), 
      child: SizedBox(
        child: Column(
          children: [
            const Text(
              'My Sensors',
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Choose a solar system you would like to track',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            isLoading ? const Center(child: CircularProgressIndicator()) : _buildSensorContent(sensorState),
          ],
        ),
    ),
    ),
  );
}

Widget _buildSensorContent(List<dynamic> sensors) {
  if (sensors.isEmpty) {
    return const Text('No Sensors Found');
  } else {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 270,
          child: GridView.count(
            crossAxisCount: 2, // Set grid layout to 2 columns
            crossAxisSpacing: 10.0, // Add spacing between grid items
            mainAxisSpacing: 10.0, // Add spacing between rows
            childAspectRatio: 2.5, // Adjust aspect ratio for wider items (optional)
            children: sensors.map((sensor) => buildSystemOption(sensor)).toList(),
          ),
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
    );
  }
}

Widget buildSystemOption(Sensor sensor) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalyticsPage(sensor: sensor),
          ),
        );
      setState(() {
        selectedSensor = sensor.name;
      });
    },
    child: Container(
      padding: const EdgeInsets.all(20.0),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
      ),
    );
  }
}
