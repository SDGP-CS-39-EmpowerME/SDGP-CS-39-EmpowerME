import 'package:flutter/material.dart';


// ignore: camel_case_types
class voiceRecorderPage extends StatelessWidget {
  const voiceRecorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return /*MaterialApp(
      debugShowCheckedModeBanner: false,
      home: */Scaffold(
      appBar: AppBar(
        title: const Text(
          "Voice Recorder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,  // Set the app bar color to light blue
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom sound waves icon (replace with your own or use an existing icon set)
            const Center(
              child: Icon(
                Icons.record_voice_over,  // Placeholder for a sound waves icon
                size: 150,  // Adjust the size as needed
                color: Colors.black,  // Set the color to black
              ),
            ),
            const SizedBox(height: 16),
            // Row of existing buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Code to handle play button click
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,  // Set button background color
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Code to handle mic button click
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,  // Set button background color
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Code to handle pause button click
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,  // Set button background color
                  ),
                  child: const Icon(
                    Icons.pause,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
    // );
  }
}

