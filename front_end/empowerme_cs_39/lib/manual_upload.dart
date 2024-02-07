import 'package:flutter/material.dart';

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Upload'),
        backgroundColor: Color(0xFF007CCF),
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
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF007CCF)), // Location Icon
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF007CCF)), // Calendar Icon
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: dateTimeController,
                    decoration: InputDecoration(
                      labelText: 'Time & Date',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to insert file data
                // This could open a file picker or some other mechanism
              },
              child: Text('Insert File'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to upload data to the cloud
              },
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
