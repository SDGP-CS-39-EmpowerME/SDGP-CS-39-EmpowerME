import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class ManualUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manual Upload App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3:true,
      ),
      home: MyHomePage(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Upload'),
        backgroundColor: const Color(0xFF007CCF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text(
            //   // 'Manual Upload',
            //   style: TextStyle(
            //     fontSize: 24.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF007CCF)), // Location Icon
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF007CCF)), // Calendar Icon
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: dateTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Time & Date',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to insert file data
                // This could open a file picker or some other mechanism
              },
              child: const Text('Insert File'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to upload data to the cloud
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
