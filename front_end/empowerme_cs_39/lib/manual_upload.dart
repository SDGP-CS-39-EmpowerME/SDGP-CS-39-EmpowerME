import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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
    var uri = Uri.parse('https://3582-45-121-90-169.ngrok-free.app/upload'); // Replace with your backend address
    var request = http.MultipartRequest('POST', uri)
      ..fields['date'] = dateController.text
      ..fields['time'] = timeController.text
      ..fields['location'] = locationController.text
      ..files.add(await http.MultipartFile.fromPath('file', _file.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully');
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
        title: Text('File Upload'),
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
