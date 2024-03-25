import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io';

class ManualUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Upload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late File _file = File(''); // Initialize with an empty file
  final picker = ImagePicker();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  Future<void> getAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadFile() async {
    if (dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        locationController.text.isEmpty) {
      print('Please enter date, time, and location');
      return;
    }

    if (_file.path.isEmpty) {
      print('No file selected');
      return;
    }

    // Extract file extension
    String extension = path.extension(_file.path);

    // Generate new file name using date, time, and location
    String fileName =
        '${dateController.text}_${timeController.text}_${locationController.text}$extension';

    try {
      // Create a multipart request with the new file name
      var uri = Uri.parse('https://3582-45-121-90-169.ngrok-free.app/upload');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', _file.path,
            filename: fileName));

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        print(fileName);
      } else {
        print('Error uploading file');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Upload'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          /*fontWeight: FontWeight.w800,*/
          color: Colors.white,
        ),
        backgroundColor: const Color.fromRGBO(0, 153, 255, 1.0),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getAudio,
              child: Text('Choose Audio File'),
            ),
            SizedBox(height: 20),
            _file.path.isNotEmpty
                ? Text('Selected File: ${_file.path}')
                : Text('No file selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadFile,
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(ManualUpload());
}
