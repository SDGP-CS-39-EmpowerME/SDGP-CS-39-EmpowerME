// ignore_for_file: file_names, prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api, unused_field, unused_import, deprecated_member_use, use_key_in_widget_constructors

/*import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smartwatch Device Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smartwatch Device Details'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'G',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'User_213',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Device',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Samsung',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Connected',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'DOO 8',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}*/




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///
///



/*import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[FitnessApi.fitnessActivityReadScope]);
  GoogleSignInAccount? _currentUser;
  String _smartwatchUsername = "N/A";
  String _smartwatchType = "N/A";

  @override
  void initState() {
    super.initState();
    _handleSignIn(); // Automatically attempt Google Sign-In on app start
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn(); // Perform Google Sign-In
      _updateUserData(); // Update user data after successful sign-in
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  Future<void> _updateUserData() async {
    if (_googleSignIn.currentUser != null) {
      _currentUser = _googleSignIn.currentUser; // Get the current user
      // Fetch additional user data from Google Fit API or other sources
      // For simplicity, we'll mock some data here
      _smartwatchUsername = "John Doe"; // Replace with actual data
      _smartwatchType = "Fitbit"; // Replace with actual data
      setState(() {}); // Trigger a UI update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connected Smartwatch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Text(
                    'Smartwatch Username:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _smartwatchUsername,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: Column(
                children: [
                  Text(
                    'Smartwatch Type:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _smartwatchType,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/