import 'package:empowerme_cs_39/auth/auth_bool.dart';
import 'package:empowerme_cs_39/auth/reset_password.dart';
import 'package:empowerme_cs_39/home_page.dart';
import 'package:empowerme_cs_39/auth/register_1_personal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/servicecontrol/v2.dart';


class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool signInSuccess = false;
  final _auth = FirebaseAuth.instance;
  bool guestLogin = false;
  AuthBool authBool = AuthBool();

  Future signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      signInSuccess = true;

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  void checkStatus() async {
    if (guestLogin == true){
      authBool.loginAsGuest = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue, // Set primary color theme
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          shape: CustomShapeBorder(),
          title: const Text(
            'EmpowerMe',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            height: 450,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueGrey[100], // Change color to shade of ash
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email or Phone Number',
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      // Validate email format
                      else if (!_isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      else {
                        _emailController.text = value;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Validate password strength
                      else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      else {
                        _passwordController.text = value;
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                            );
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      signIn().then((_) {
                        // Login successful! Navigate to HomePage
                        if (signInSuccess == true){
                          authBool.loginAsGuest = false;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                        else if (signInSuccess == false){
                          if (_passwordController.text.trim().length < 6){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Password should be at least 6 characters long.'),
                              ),
                            );
                          }
                          else if (!_isValidEmail(_emailController.text.trim())){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Please enter a valid email address.'),
                              ),
                            );
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Invalid email or password.'),
                              ),
                            );
                          }
                        }
                      }).catchError((error) {
                        // Handle sign-in errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(error.message!),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),

                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      //guestLogin = true;
                      /*await checkStatus();*/
                      authBool.loginAsGuest = true;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: const Text(
                      'Login as Guest',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          authBool.loginAsGuest = false;
                          Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPersonalDetails()),
                    );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.blue[900]), // Change to dark blue
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double curverRadius = 30;
    Path path = Path();
    path.lineTo(0, rect.height - curverRadius);
    path.quadraticBezierTo(
        rect.width / 4, rect.height, rect.width / 2, rect.height);
    path.quadraticBezierTo(rect.width - (rect.width / 4), rect.height,
        rect.width, rect.height - curverRadius);
    path.lineTo(rect.width, 0);
    path.close();
    return path;
  }
}

bool _isValidEmail(String email) {
  // Simple email validation using regex
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool _isValidPhoneNumber(String phoneNumber) {
  // Simple phone number validation
  final phoneRegex = RegExp(r'^\d{10}$'); // Adjust as per your requirement
  return phoneRegex.hasMatch(phoneNumber);
}
