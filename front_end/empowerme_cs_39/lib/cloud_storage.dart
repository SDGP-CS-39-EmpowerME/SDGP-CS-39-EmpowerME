import 'package:flutter/material.dart';

import 'cloud_storage_access_page.dart';


// ignore: use_key_in_widget_constructors
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

// ignore: use_key_in_widget_constructors
class CloudStoragePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Storage'),
        backgroundColor: const Color(0xFF3377A8),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFF3377A8),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Icon(Icons.cloud, size: 80.0, color: Colors.white),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Backup Account (Gmail)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
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
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Last Upload Date and Time',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                // Handle dropdown menu visibility
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Row(
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
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CloudStorageAccessPage()),
                );
              },
              child: const Text('Cloud Storage Access'),
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

// class CloudStorageAccessPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cloud Storage Access'),
//         backgroundColor: Color(0xFF3377A8),
//       ),
//       body: Center(
//         child: Text(
//           'This is the Cloud Storage Access page',
//           style: TextStyle(fontSize: 20.0),
//         ),
//       ),
//     );
//   }
// }
