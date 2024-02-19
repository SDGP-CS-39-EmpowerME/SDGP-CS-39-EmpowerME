import 'package:flutter/material.dart';


class CloudStorage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Storage Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CloudStoragePage(),
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Color(0xFF3377A8),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Icon(Icons.cloud, size: 80.0, color: Colors.white),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Backup Account (Gmail)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!isValidEmail(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Last Upload Date and Time',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                // Handle dropdown menu visibility
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'View Full History',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CloudStorageAccessPage()),
                );
              },
              child: Text('Cloud Storage Access'),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String value) {
    // Simple email validation regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
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
      body: Center(
        child: Text(
          'This is the Cloud Storage Access page',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
