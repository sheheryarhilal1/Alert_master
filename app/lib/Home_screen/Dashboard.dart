import 'package:app/Home_screen/pressure.dart';
import 'package:flutter/material.dart';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

MqttServerClient? client;

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

  String mqttBroker = "test.mosquitto.org";
  String clientId = "flutter_mqtt_client2";
  int port = 1883;
  String publishStatus = "";

  // Map to store high and low values for each title
  final Map<String, Map<String, String>> _containerValues = {
    'Chilled water in': {'High': '25', 'Low': '15'},
    'Chilled water out': {'High': '26', 'Low': '16'},
    'Suction temp': {'High': '27', 'Low': '17'},
    'Discharge temp': {'High': '27', 'Low': '17'},
  };

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
    _connectMqtt();
  }

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

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  Future<void> _connectMqtt() async {
    try {
      await client?.connect();
      print('Connected');
    } catch (e) {
      print('Exception: $e');
      client?.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient(mqttBroker, clientId);
    client?.port = port;
    client?.logging(on: true);
    client?.onDisconnected = _onDisconnected;
    client?.onConnected = _onConnected;
    client?.onSubscribed = _onSubscribed;
  }

  void _onDisconnected() {
    print('Disconnected from MQTT broker.');
  }

  void _publishMessage(String topic, String message, {bool retain = false}) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage(topic, MqttQos.atMostOnce, builder.payload!,
        retain: retain);
  }

  // Map<String, dynamic> _buildJsonPayload() {
  //   return {
  //     "seasonsw": isSummer,
  //     "dmptempsp": _thermostatTemperature,
  //     "dampertsw": isOn,
  //     "supcfm":
  //         "${_currentRangeValues.start.round()} - ${_currentRangeValues.end.round()}",
  //     "timesch": "selectedDateTime",
  //     "dampstate": isOn,
  //     "packet_id": packet_id
  //   };
  // }

  // Create a method to publish the JSON message
  String _publishJsonMessage() {
    // ignore: unused_local_variable
    final String topic =
        '/KRC_AM/1'; // Specify the topic where you want to publish
    // packet_id++;
    final String jsonPayload = "jsonEncode(_containerValues)";
    // _publishMessage(topic, jsonPayload, retain: true);
    publishMessage(jsonPayload);
    return jsonPayload;
  }

  void publishMessage(String message) {
    const String topic = "/KRC_AM/1";
    // const String message = "Winter";

    if (client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);

      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: true,
        );
        setState(() {
          publishStatus =
              'Message "$message" published successfully to topic "$topic" with retain flag.';
        });
      } catch (e) {
        setState(() {
          publishStatus = 'Failed to publish message: $e';
        });
      }
    }
  }

  void _onConnected() {
    print('Connected to MQTT broker.');

    // Subscribe to specified topics
    // client?.subscribe('/KRC/1', MqttQos.atLeastOnce);
    // client?.subscribe('/KRC/2', MqttQos.atLeastOnce);
    // client?.subscribe('/KRC/3', MqttQos.atLeastOnce);
    // client?.subscribe('/KRC/4', MqttQos.atLeastOnce);
    // client?.subscribe('thermostat/temp', MqttQos.atLeastOnce);
    // client?.subscribe('thermostat/range', MqttQos.atLeastOnce);
    // client?.subscribe('thermostat/switch', MqttQos.atLeastOnce);

    client?.updates!.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
      final MqttPublishMessage msg = c![0].payload as MqttPublishMessage;

      final String topic = c[0].topic;
      final String message =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);

      // setState(() {
      //   receivedMessage = message;

      // switch (topic) {
      //   case '/KRC/1':
      //     // Handle message for /KRC/1
      //     break;
      //   case '/KRC/2':
      //     // Handle message for /KRC/2
      //     break;
      //   case '/KRC/3':
      //     // Handle message for /KRC/3
      //     break;
      //   case '/KRC/4':
      //     // Handle message for /KRC/4
      //     break;
      //   case 'thermostat/temp':
      //     _thermostatTemperature =
      //         double.tryParse(message) ?? _thermostatTemperature;
      //     break;
      //   case 'thermostat/range':
      //     List<String> values = message.split('-');
      //     if (values.length == 2) {
      //       _currentRangeValues = RangeValues(
      //         double.tryParse(values[0]) ?? _currentRangeValues.start,
      //         double.tryParse(values[1]) ?? _currentRangeValues.end,
      //       );
      //     }
      //     break;
      //   case 'thermostat/switch':
      //     isOn = message == "ON";
      //     break;
      // }
      // }
      // );
    });
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
                final String jsonPayload =
                    jsonEncode("Temperature:${tempController.text}");
                publishMessage(jsonPayload);
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
                final String jsonPayload = jsonEncode(
                    "Temperature:${tempController.text}High:${highTempController.text}Low:${lowTempController.text}");
                publishMessage(jsonPayload);
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
