import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ModelCall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Model Call'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Get the directory for app recordings
              Directory? appRecordingsDir =
                  await getExternalStorageDirectory(); // Note the nullability

              if (appRecordingsDir == null) {
                print("External storage directory not found");
                return;
              }

              Directory appRecordingsDirPath =
                  Directory(path.join(appRecordingsDir.path, 'App Recordings'));
              Directory confirmViolenceDirPath = Directory(
                  path.join(appRecordingsDir.path, 'Confirm violence'));

              // Create Confirm violence directory if it doesn't exist
              if (!(await confirmViolenceDirPath.exists())) {
                await confirmViolenceDirPath.create(recursive: true);
              }

              // Get the list of .wav files
              List<FileSystemEntity> wavFiles = appRecordingsDirPath
                  .listSync()
                  .where((entity) => entity.path.toLowerCase().endsWith('.wav'))
                  .toList();

              // Send each .wav file to the model
              for (var wavFile in wavFiles) {
                await sendAndProcessWavFile(wavFile, confirmViolenceDirPath);
              }
            },
            child: Text('Send .wav Files'),
          ),
        ),
      ),
    );
  }

  Future<void> sendAndProcessWavFile(
      FileSystemEntity wavFile, Directory confirmViolenceDirPath) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://e495-2402-4000-2081-605b-c62-f256-7bb8-9be0.ngrok-free.app/predict'),
      );

      // Add the .wav file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        wavFile.path,
        filename: path.basename(wavFile.path),
      ));

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        // Process the response
        var responseBody = await response.stream.bytesToString();
        var emotion = int.tryParse(responseBody);

        if (emotion != null && emotion >= 0 && emotion < 7) {
          // Check if emotion indicates domestic violence
          if (emotion <= 2) {
            // Move the audio clip to Confirm violence folder
            await wavFile.rename(path.join(
                confirmViolenceDirPath.path, path.basename(wavFile.path)));
            print(
                'Successfully moved file: ${path.basename(wavFile.path)} to Confirm violence folder');
          } else {
            // Delete the audio clip
            await wavFile.delete();
            print('Successfully deleted file: ${path.basename(wavFile.path)}');
          }
        } else {
          print('Invalid emotion received from server');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }
}
