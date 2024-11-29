import 'package:app/Home_screen/ampere_screen.dart';
import 'package:flutter/material.dart';

class AmpereScreen extends StatefulWidget {
  const AmpereScreen({super.key});

  @override
  State<AmpereScreen> createState() => _DashboardState();
}

class _DashboardState extends State<AmpereScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Center(),
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
                        Icons.electric_bolt,
                        size: 30,
                        color: Colors.red,
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
              const SizedBox(height: 30),

              // Containers with icons, text, and subtitles on left and right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                    icon: Icons.electric_bolt,
                    color: Colors.blue,
                    title: 'Chilled water in',
                    subtitle: 'Temperature: 25\nHigh\nLow',
                  ),
                  _buildInfoCard(
                    icon: Icons.electric_bolt,
                    color: Colors.orange,
                    title: 'Chilled water out',
                    subtitle: 'Temperature: 25\nHigh\nLow',
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                    icon: Icons.electric_bolt,
                    color: Colors.green,
                    title: 'Suction temp',
                    subtitle: 'Temperature: 25\nHigh\nLow',
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Pressure container with navigation to AmpereScreen
            ],
          ),
        ),
      ),
    );
  }

  // Reusable info card widget
  Widget _buildInfoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
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
    );
  }
}
