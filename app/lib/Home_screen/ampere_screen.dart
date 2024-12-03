import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

MqttServerClient? client;

class AmpereScreen extends StatefulWidget {
  const AmpereScreen({super.key});

  @override
  State<AmpereScreen> createState() => _DashboardState();
}

class _DashboardState extends State<AmpereScreen> {
  int _currentIndex = 0;

  String mqttBroker = "test.mosquitto.org";
  String clientId = "flutter_mqtt_client2";
  int port = 1883;
  String publishStatus = "";

  // Map to store high and low values for each title
  final Map<String, Map<String, String>> _containerValues = {
    'Chilled water in': {'High': '25', 'Low': '15'},
    'Chilled water out': {'High': '26', 'Low': '16'},
    'Suction temp': {'High': '27', 'Low': '17'},
  };

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
    _connectMqtt();
  }

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
                          Icons.electric_bolt_sharp,
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

                // Info cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard(
                      icon: Icons.electric_bolt_sharp,
                      color: Colors.blue,
                      title: 'Chilled water in',
                    ),
                    _buildInfoCard(
                      icon: Icons.electric_bolt_sharp,
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
                      icon: Icons.electric_bolt_sharp,
                      color: Colors.green,
                      title: 'Suction temp',
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Navigation to AmpereScreen
              ]),
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
    final String jsonPayload = jsonEncode(_containerValues);
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
                _publishJsonMessage();
                setState(() {
                  _containerValues[title] = {
                    'High': highController.text,
                    'Low': lowController.text,
                  };
                });
                Navigator.pop(context);
                _publishJsonMessage();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
