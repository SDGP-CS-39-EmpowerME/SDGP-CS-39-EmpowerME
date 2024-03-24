import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class CloudStorage extends StatefulWidget {
  @override
  _CloudStorageState createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> {
  bool _autoUploadEnabled = false;
  String _currentLoginEmail = '';
  String _lastUploadedFile = '';
  String _authUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Upload'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          /*fontWeight: FontWeight.w800,*/
          color: Colors.white,
        ),
        backgroundColor: const Color.fromRGBO(0, 153, 255, 1.0),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '$_currentLoginEmail',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Auto Upload',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8), // Add some space between text and switch
                Switch(
                  value: _autoUploadEnabled,
                  onChanged: (value) {
                    setState(() {
                      _autoUploadEnabled = value;
                      if (_autoUploadEnabled) {
                        // Trigger the authentication process
                        initiateAuthentication();
                      }
                    });
                  },
                  activeColor: Colors.blue, // Color when switch is on
                  activeTrackColor: Colors.lightBlueAccent, // Color of track when switch is on
                  inactiveThumbColor: Colors.grey, // Color of the thumb when switch is off
                  inactiveTrackColor: Colors.grey[300], // Color of track when switch is off
                  //activeThumbImage: AssetImage('assets/on_icon.png'), // Image when switch is on
                  //inactiveThumbImage: AssetImage('assets/off_icon.png'), // Image when switch is off
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '$_lastUploadedFile',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          // WebView widget to display the authentication page
          if (_authUrl.isNotEmpty)
            Expanded(
              child: WebView(
                initialUrl: _authUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (String url) {
                  if (url.startsWith('https://3582-45-121-90-169.ngrok-free.app/oauth2callback')) {
                    // Extract code from URL
                    var uri = Uri.parse(url);
                    var code = uri.queryParameters['code'];
                    // Exchange code for tokens
                    exchangeCodeForTokens(code);
                    // Open the URL in the default browser again
                    launchAuthUrlAgain();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  void initiateAuthentication() async {
    // Directly open the authentication URL in the default browser or web view
    var authUrl = 'https://accounts.google.com/o/oauth2/v2/auth?access_type=offline&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&response_type=code&client_id=800910222707-27hmuoopb6ri9oin95erm4da9qmbva7u.apps.googleusercontent.com&redirect_uri=https%3A%2F%2F3582-45-121-90-169.ngrok-free.app%2Foauth2callback';

    // Open the URL in the default browser or web view
    if (await canLaunch(authUrl)) {
      await launch(authUrl);
    } else {
      print('Could not launch $authUrl');
    }
  }

  void launchAuthUrlAgain() async {
    // Open the URL in the default browser or web view
    if (await canLaunch(_authUrl)) {
      await launch(_authUrl);
    } else {
      print('Could not launch $_authUrl');
    }
  }

  void exchangeCodeForTokens(String? code) async {
    if (code != null) {
      // Exchange code for tokens with backend
      var response = await http.get(Uri.parse('https://3582-45-121-90-169.ngrok-free.app/oauth2callback?code=$code'));
      var tokens = jsonDecode(response.body);

      // Store tokens, update UI, and trigger auto-upload
      setState(() {
        _currentLoginEmail = tokens['email'] as String; // Update email if available
        _lastUploadedFile = tokens['lastUploadedFile'] as String; // Update last uploaded file
      });
      if (_autoUploadEnabled) {
        autoUploadFiles(tokens['tokens'] as Map<String, dynamic>);
      }
    }
  }

  void autoUploadFiles(Map<String, dynamic> tokens) async {
    // Implement auto-upload functionality here
    // You can make authenticated requests to upload files to Google Drive using the tokens
  }
  Future<void> _getFolderPathAndUpload() async {
    try {
      String? folderPath = await _getFolderPath();
      if (folderPath != null) {
        _sendFolderPathToBackend(folderPath);
      } else {
        print('No folder path selected');
      }
    } catch (error) {
      print('Error selecting folder path: $error');
    }
  }

  Future<String?> _getFolderPath() async {
    FilePickerResult? result = (await FilePicker.platform.getDirectoryPath()) as FilePickerResult?;
    if (result != null) {
      // Assuming you only pick one path, you can access it like this
      String? folderPath = result.paths.first;
      return folderPath;
    }
    return null;
  }

  void _sendFolderPathToBackend(String folderPath) async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://3582-45-121-90-169.ngrok-free.app'), // Replace with your backend URL
        body: {'com.android.externalstorage.documents/tree/primary%3ADownload%2FAudios/document/primary%3ADownload%2FAudios': folderPath},
      );

      if (response.statusCode == 200) {
        print('Folder path sent to backend');
      } else {
        print('Failed to send folder path to backend');
      }
    } catch (error) {
      print('Error sending folder path to backend: $error');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CloudStorage(),
    );
  }
}

void main() {
  runApp(MyApp());
}
