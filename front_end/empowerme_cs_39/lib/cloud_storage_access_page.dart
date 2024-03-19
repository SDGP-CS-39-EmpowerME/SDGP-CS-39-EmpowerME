import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class CloudStorageAccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Storage Access Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CloudStorageAccessPage(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class CloudStorageAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Storage Access'),
        backgroundColor: const Color(0xFF3377A8),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFF3377A8),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Icon(Icons.cloud, size: 80.0, color: Colors.white), // Replaced Icons.drive with Icons.cloud
            const SizedBox(height: 20.0),
            const Text(
              'Google Address',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10.0),
            const TextField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Backup Frequency',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10.0),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Live Backup', style: TextStyle(color: Colors.white)),
                  value: 'Live Backup',
                  groupValue: null,
                  onChanged: (value) {
                    // Handle live backup selection
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Daily Backup', style: TextStyle(color: Colors.white)),
                  value: 'Daily Backup',
                  groupValue: null,
                  onChanged: (value) {
                    // Handle daily backup selection
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Weekly Backup', style: TextStyle(color: Colors.white)),
                  value: 'Weekly Backup',
                  groupValue: null,
                  onChanged: (value) {
                    // Handle weekly backup selection
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Cloud Storage page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CloudStoragePage()),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class CloudStoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Storage'),
        backgroundColor: const Color(0xFF3377A8),
      ),
      body: const Center(
        child: Text(
          'This is the Cloud Storage page',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
