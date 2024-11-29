import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isCompressorOn = false; // Initial status of the compressor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Apply the gradient directly to the Scaffold background
      backgroundColor: Colors.transparent, // To allow the gradient to show
      body: Container(
        // The gradient as a decoration for the entire container
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Glass effect container
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCompressorOn = !isCompressorOn;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white54
                          .withOpacity(0.2), // Semi-transparent background
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Text(
                      'Compressor Status: ${isCompressorOn ? 'ON' : 'OFF'}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isCompressorOn ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      20), // Add some spacing between glassy effect and new container

              // New container with Icon and Text
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.3), // Semi-transparent background
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // To wrap the content
                    children: [
                      Icon(
                        Icons.thermostat, // Thermostat icon for temperature
                        size: 30,
                        color: Colors.red, // Icon size
                      ),
                      const SizedBox(width: 10), // Space between icon and text
                      Text(
                        'Temperature',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30), // Add spacing for the new section

              // Containers with icons, text, and subtitles on left and right
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Spread out left and right
                children: [
                  // Left Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.3), // Semi-transparent background
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    width: MediaQuery.of(context).size.width *
                        0.4, // 40% of screen width
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.thermostat, // Example icon (Air conditioner)
                          size: 40,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Chilled water in ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Temperature :25', // Subtitle
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  // Right Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.3), // Semi-transparent background
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    width: MediaQuery.of(context).size.width *
                        0.4, // 40% of screen width
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.thermostat, // Example icon (Settings)
                          size: 40,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'chilled water out',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Temperature 25', // Subtitle
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30), // Add some spacing between new row

              // Additional two containers in left and right
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Spread out left and right
                children: [
                  // Left Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.3), // Semi-transparent background
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    width: MediaQuery.of(context).size.width *
                        0.4, // 40% of screen width
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.thermostat, // Example icon (Air flow)
                          size: 40,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Suction temp',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text('Temperature 25'),
                        Text(
                          'High', // Subtitle
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Low', // Subtitle
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  // Right Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.3), // Semi-transparent background
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    width: MediaQuery.of(context).size.width *
                        0.4, // 40% of screen width
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.thermostat, // Example icon (Power)
                          size: 40,
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Discharge temp',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text('Temperature 25'),
                        Text(
                          'High', // Subtitle
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Low', // Subtitle
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // New container with Icon and Text in center
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.3), // Semi-transparent background
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // To wrap the content
                    children: [
                      Icon(
                        Icons.air, // Example icon (Alarm)
                        size: 30,
                        color: Colors.blue, // Icon color
                      ),
                      const SizedBox(width: 10), // Space between icon and text
                      Text(
                        'Pressure',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
