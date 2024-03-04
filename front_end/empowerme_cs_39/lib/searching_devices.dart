import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Range Visualization',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothRangePage(),
    );
  }
}

class BluetoothRangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smartwatch'),
        backgroundColor: Color(0xFF007CCF),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Search Device',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: BluetoothRangeVisualization(),
          ),
        ],
      ),
    );
  }
}

class BluetoothRangeVisualization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circles representing Bluetooth range zones
          BluetoothRangeCircle(radius: 100.0, opacity: 0.5),
          BluetoothRangeCircle(radius: 200.0, opacity: 0.3),
          BluetoothRangeCircle(radius: 300.0, opacity: 0.1),
          // You can add more circles for different range zones
          Icon(Icons.bluetooth, size: 100.0, color: Colors.white),
        ],
      ),
    );
  }
}

class BluetoothRangeCircle extends StatelessWidget {
  final double radius;
  final double opacity;

  const BluetoothRangeCircle(
      {Key? key, required this.radius, required this.opacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(opacity),
      ),
    );
  }
}
