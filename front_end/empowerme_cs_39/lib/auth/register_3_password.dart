import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:empowerme_cs_39/auth/register_userdata.dart';
import 'package:empowerme_cs_39/home_page.dart';
import 'dart:developer';

class RegisterPassword extends StatefulWidget {
  const RegisterPassword({Key? key}) : super(key: key);

  @override
  State<RegisterPassword> createState() => _RegisterPasswordState();
}

bool agree = false;

class _RegisterPasswordState extends State<RegisterPassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool passwordCorrect = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signUp(userData) async {
    if (passwordConfirmed()) {
      //create user
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userData.email,
          password: _passwordController.text.trim(),
        );
        passwordCorrect = true;
      } on FirebaseAuthException catch (e) {
        return e.message;
      }

      //adds user details
      addUserDetails(
        userData.name,
        userData.email,
        userData.nic,
        userData.address,
        userData.birthday,
        userData.secondPersonName,
        userData.secondPersonBirthday,
        userData.phone,
        userData.familyCount,
      );
    }
  }

  Future <void> addUserDetails(
    String name,
    String email,
    String nic,
    String address,
    String birthday,
    String secondPersonName,
    String secondPersonBirthday,
    String phone,
    String familyCount,
    /*required String password,*/
  ) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'email': email,
      'nic': nic,
      'address': address,
      'birthday': birthday,
      'secondPersonName': secondPersonName,
      'secondPersonBirthday': secondPersonBirthday,
      'phone': phone,
      'familyCount': familyCount,
      /*'password': password, */// Assuming password is stored securely
    });
  }


  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context); // Access user data
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView( // Allows content to scroll if needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildInputField(
                    Icons.lock, "Password", (value) =>
                _passwordController.text = value),
                SizedBox(height: 20),
                _buildInputField(
                    Icons.lock,
                    "Confirm Password",
                        (value) => _confirmPasswordController.text = value),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (value) {
                        setState(() {
                          agree = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "I agree with the ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge!
                                .color, // Use the default text color
                          ),
                          children: const <TextSpan>[
                            TextSpan(
                              text: "Terms and Conditions",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all the fields.'),
                        ),
                      );
                    } else if (!passwordConfirmed()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match.'),
                        ),
                      );
                    } else if (!agree) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please agree to the terms and conditions.'),
                        ),
                      );
                    } else if (_passwordController.text.trim().length < 6){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Password should be at least 6 characters long.'),
                        ),
                      );
                    }
                    else {
                      signUp(userData);
                      if (passwordCorrect){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String labelText,
      Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
