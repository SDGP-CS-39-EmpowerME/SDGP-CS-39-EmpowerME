import 'package:flutter/material.dart';

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

class CloudStorageAccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Storage Access'),
        backgroundColor: Color(0xFF3377A8),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Color(0xFF3377A8),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Icon(Icons.cloud, size: 80.0, color: Colors.white), // Replaced Icons.drive with Icons.cloud
            SizedBox(height: 20.0),
            Text(
              'Google Address',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10.0),
            TextField(
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
            SizedBox(height: 20.0),
            Text(
              'Backup Frequency',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10.0),
            Column(
              children: [
                RadioListTile<String>(
                  title: Text('Live Backup', style: TextStyle(color: Colors.white)),
                  value: 'Live Backup',
                  groupValue: null,
                  onChanged: (value) {
                    // Handle live backup selection
                  },
                ),
                RadioListTile<String>(
                  title: Text('Daily Backup', style: TextStyle(color: Colors.white)),
                  value: 'Daily Backup',
                  groupValue: null,
                  onChanged: (value) {
                    // Handle daily backup selection
                  },
                ),
                RadioListTile<String>(
                  title: Text('Weekly Backup', style: TextStyle(color: Colors.white)),
                  value: 'Weekly Backup',
                  groupValue: null,
                  onChanged: (value) {
                    // Handle weekly backup selection
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Cloud Storage page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CloudStoragePage()),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

class CloudStoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Storage'),
        backgroundColor: Color(0xFF3377A8),
      ),
      body: Center(
        child: Text(
          'This is the Cloud Storage page',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
