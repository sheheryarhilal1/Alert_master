import 'package:app/Home_screen/ampere_screen.dart';
import 'package:flutter/material.dart';

class PressureScreen extends StatefulWidget {
  const PressureScreen({super.key});

  @override
  State<PressureScreen> createState() => _DashboardState();
}

class _DashboardState extends State<PressureScreen> {
  int _currentIndex = 0;

  // Map to store high and low values for each title
  final Map<String, Map<String, String>> _containerValues = {
    'Chilled water in': {'High': '25', 'Low': '15'},
    'Chilled water out': {'High': '26', 'Low': '16'},
    'Suction temp': {'High': '27', 'Low': '17'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Avoid the keyboard resizing the screen
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
              const Center(),
              const SizedBox(height: 20),

              // Title container
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
                        Icons.air,
                        size: 30,
                        color: Colors.red,
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
              const SizedBox(height: 30),

              // Info cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                    icon: Icons.air,
                    color: Colors.blue,
                    title: 'Chilled water in',
                  ),
                  _buildInfoCard(
                    icon: Icons.air,
                    color: Colors.orange,
                    title: 'Chilled water out',
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                    icon: Icons.air,
                    color: Colors.green,
                    title: 'Suction temp',
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Navigation to AmpereScreen
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AmpereScreen(),
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
                          Icons.electric_bolt_outlined,
                          size: 30,
                          color: Colors.yellowAccent,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Ampere',
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
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Reusable info card widget with dialog functionality
  Widget _buildInfoCard({
    required IconData icon,
    required Color color,
    required String title,
  }) {
    final high = _containerValues[title]?['High'] ?? 'N/A';
    final low = _containerValues[title]?['Low'] ?? 'N/A';

    return GestureDetector(
      onTap: () {
        _showDialog(title);
      },
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'High: $high\nLow: $low',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Show dialog for high and low input
  void _showDialog(String title) {
    final TextEditingController highController =
        TextEditingController(text: _containerValues[title]?['High']);
    final TextEditingController lowController =
        TextEditingController(text: _containerValues[title]?['Low']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Levels for $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: highController,
                decoration: const InputDecoration(labelText: 'High Level'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lowController,
                decoration: const InputDecoration(labelText: 'Low Level'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _containerValues[title] = {
                    'High': highController.text,
                    'Low': lowController.text,
                  };
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
