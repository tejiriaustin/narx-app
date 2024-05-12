import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:narx_app/view_models/sensors.dart';
import 'package:narx_app/widgets/navigation.dart';


class AnalyticsPage extends StatefulWidget {
  final Sensor sensor;

  const AnalyticsPage({super.key, required this.sensor});

  @override
  AnalyticsPageState createState() => AnalyticsPageState();
}

class AnalyticsPageState extends State<AnalyticsPage> {
  // Add state variables if needed (e.g., for panel data)
  final NavigationState navigationState = NavigationState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider(
        create: (context) => navigationState,
        child: page(context, widget.sensor),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.battery_charging_full), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: navigationState.selectedIndex,
        onTap: (int index) {
          navigationState.selectedIndex = index;
          // Optionally handle additional navigation logic here
        },
      ),
    );
  }


  Widget page(BuildContext context, Sensor sensor) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), 
        child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space widgets evenly
                children: [
                  Text('Hi ${sensor.accountInfo.firstName}!', style: const TextStyle(fontSize: 24.0)),
                  const Icon(Icons.notifications), // Notification icon
                ],
              ),
              const SizedBox(height: 40.0), // Add spacing,
              
              const Center(
                child: Text(
                  'Todays Energy Usage',
                  style: TextStyle(fontSize: 24.0),
                )
              ),
              const SizedBox(height: 20.0), // Add spacing,
              Card(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Panels:', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                          Text('0', style: TextStyle(color: Colors.white, fontSize: 18.0)), // Replace with logic to get total panels
                        ],
                      ),
                      const SizedBox(height: 10.0), // Add spacing between rows

                      // Row for Panel Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Panel Status:', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                          Text(widget.sensor.status, style: const TextStyle(color: Colors.white, fontSize: 18.0)), // Replace with logic to get panel status
                        ],
                      ),
                      const SizedBox(height: 10.0), // Add spacing between rows

                      // Row for Sensor Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sensor Name:', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                          Text(widget.sensor.name, style: const TextStyle(color: Colors.white, fontSize: 18.0)), // Assuming sensor name is same as title
                        ],
                      ),
                      const SizedBox(height: 10.0), // Add spacing between rows

                      // Row for Sensor IP Address
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sensor IP Address:', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                          Text(widget.sensor.ipAddress, style: const TextStyle(color: Colors.white, fontSize: 18.0)), // Replace with logic to get sensor IP
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // ... other widgets in the column,
            ],
          ),
        ),
      ),
    );
  }
}
