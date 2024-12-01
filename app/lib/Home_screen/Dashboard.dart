import 'package:app/Home_screen/pressure.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isCompressorOn = false;
  int _currentIndex = 0;
  String chilledWaterInTemp = '25';
  String chilledWaterOutTemp = '25';
  String suctionTemp = '25';
  String suctionHighTemp = '30';
  String suctionLowTemp = '20';
  String dischargeTemp = '35';
  String dischargeHighTemp = '40';
  String dischargeLowTemp = '30';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Allow the body to resize when the keyboard appears
      backgroundColor: Colors.transparent,
      body: Container(
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
                      color: Colors.white54.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
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
              const SizedBox(height: 20),

              // New container with Icon and Text
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.thermostat,
                        size: 30,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
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
              const SizedBox(height: 30),

              // Containers with icons, text, and subtitles on left and right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                    icon: Icons.thermostat,
                    color: Colors.blue,
                    title: 'Chilled water in',
                    subtitle: 'Temperature: $chilledWaterInTemp',
                    onTap: () => _showTemperatureDialog(
                      context,
                      'Chilled water in',
                      chilledWaterInTemp,
                      (newTemp) {
                        setState(() {
                          chilledWaterInTemp = newTemp;
                        });
                      },
                    ),
                  ),
                  _buildInfoCard(
                    icon: Icons.thermostat,
                    color: Colors.orange,
                    title: 'Chilled water out',
                    subtitle: 'Temperature: $chilledWaterOutTemp',
                    onTap: () => _showTemperatureDialog(
                      context,
                      'Chilled water out',
                      chilledWaterOutTemp,
                      (newTemp) {
                        setState(() {
                          chilledWaterOutTemp = newTemp;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                    icon: Icons.thermostat,
                    color: Colors.green,
                    title: 'Suction temp',
                    subtitle:
                        'Temperature: $suctionTemp\nHigh: $suctionHighTemp\nLow: $suctionLowTemp',
                    onTap: () => _showSuctionDischargeTempDialog(
                      context,
                      'Suction temp',
                      suctionTemp,
                      suctionHighTemp,
                      suctionLowTemp,
                      (temp, highTemp, lowTemp) {
                        setState(() {
                          suctionTemp = temp;
                          suctionHighTemp = highTemp;
                          suctionLowTemp = lowTemp;
                        });
                      },
                    ),
                  ),
                  _buildInfoCard(
                    icon: Icons.thermostat,
                    color: Colors.purple,
                    title: 'Discharge temp',
                    subtitle:
                        'Temperature: $dischargeTemp\nHigh: $dischargeHighTemp\nLow: $dischargeLowTemp',
                    onTap: () => _showSuctionDischargeTempDialog(
                      context,
                      'Discharge temp',
                      dischargeTemp,
                      dischargeHighTemp,
                      dischargeLowTemp,
                      (temp, highTemp, lowTemp) {
                        setState(() {
                          dischargeTemp = temp;
                          dischargeHighTemp = highTemp;
                          dischargeLowTemp = lowTemp;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Pressure container with navigation
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PressureScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.air,
                          size: 30,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10),
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }

  // Reusable info card widget with onTap
  Widget _buildInfoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // Method to show the temperature update dialog
  void _showTemperatureDialog(BuildContext context, String title,
      String currentTemp, Function(String) onUpdate) {
    TextEditingController tempController =
        TextEditingController(text: currentTemp);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update $title Temperature'),
          content: TextField(
            controller: tempController,
            decoration: InputDecoration(
              labelText: 'New Temperature',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                onUpdate(tempController.text); // Update the temperature
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without updating
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Method to show the suction/discharge temp dialog
  void _showSuctionDischargeTempDialog(
      BuildContext context,
      String title,
      String currentTemp,
      String currentHighTemp,
      String currentLowTemp,
      Function(String, String, String) onUpdate) {
    TextEditingController tempController =
        TextEditingController(text: currentTemp);
    TextEditingController highTempController =
        TextEditingController(text: currentHighTemp);
    TextEditingController lowTempController =
        TextEditingController(text: currentLowTemp);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update $title Temperature'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tempController,
                decoration: const InputDecoration(
                  labelText: 'Temperature',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: highTempController,
                decoration: const InputDecoration(
                  labelText: 'High Temperature',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lowTempController,
                decoration: const InputDecoration(
                  labelText: 'Low Temperature',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                onUpdate(
                  tempController.text,
                  highTempController.text,
                  lowTempController.text,
                ); // Update suction/discharge temperature values
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without updating
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
