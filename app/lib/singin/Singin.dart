import 'package:flutter/material.dart';

class MyHomes extends StatelessWidget {
  const MyHomes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color with low opacity
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.yellow.withOpacity(1.0), // Yellow with 80% opacity
                  Colors.red.withOpacity(0.5), // Red with 80% opacity
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Positioned text at the top left
          Positioned(
            top: 20, // Adjust the distance from the top
            left: 20, // Adjust the distance from the left
            child: Text(
              'Alert Master',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
