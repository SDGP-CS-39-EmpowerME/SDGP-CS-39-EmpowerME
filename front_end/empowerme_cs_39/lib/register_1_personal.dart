
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPersonalDetails extends StatelessWidget {
  const RegisterPersonalDetails({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildRegistrationContainer(context),
        ),
      ),
    );
  }

  Widget _buildRegistrationContainer(BuildContext context) {
    String name = '';
    String email = '';
    String nic = '';
    String address = '';
    String birthDay = '';

    return Container(
      height: 450,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 199, 220, 229),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Personal Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildInputField(Icons.person, 'Name', (value) {
            name = value;
          }),
          _buildInputField(Icons.email, 'Email or Phone Number', (value) {
            email = value;
            /*return TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email or Phone Number',
              ),
              onChanged: onChanged,
              validator: (value) {
                if (value!.isNotEmpty && !EmailValidator.validate(value!)) {
                  return 'Please enter a valid email address';
                }
                return null; // No validation error
              },
            );*/
          }),

          _buildInputField(Icons.assignment_ind, 'NIC/Passport Number',
              (value) {
            nic = value;
          }),
          _buildInputField(Icons.home, 'Address', (value) {
            address = value;
          }),
          _buildInputField(Icons.cake, 'Birthday', (value) {
            birthDay = value;
          }),
          ElevatedButton(
            onPressed: () {
              if (name.isEmpty ||
                  email.isEmpty ||
                  nic.isEmpty ||
                  address.isEmpty ||
                  birthDay.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all the fields.'),
                  ),
                );
              } else {
                Navigator.pushNamed(context, '/family_details');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      IconData icon, String labelText, Function(String) value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        onChanged: value,
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


