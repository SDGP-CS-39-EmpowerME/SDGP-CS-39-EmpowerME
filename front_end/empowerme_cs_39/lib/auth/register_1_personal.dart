import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart'; // Import for email validation
import 'package:provider/provider.dart';
import 'package:empowerme_cs_39/auth/register_userdata.dart';


class RegisterPersonalDetails extends StatefulWidget {
  const RegisterPersonalDetails({Key? key}) : super(key: key);

  @override
  State<RegisterPersonalDetails> createState() => _RegisterPersonalDetailsState();
}

class _RegisterPersonalDetailsState extends State<RegisterPersonalDetails> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nicController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    super.dispose();
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
          child: Container(
            height: 490,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 199, 220, 229),
            ),
            child: SingleChildScrollView( // Allows content to scroll if needed
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
                  _buildInputField(
                    Icons.person,
                    'Name',
                    _nameController,
                  ),
                  _buildInputField(
                    Icons.email,
                    'Email Address',
                    _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email address.';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email address.';
                      } else {
                        return null; // No error
                      }
                    },
                  ),
                  _buildInputField(
                    Icons.assignment_ind,
                    'NIC/Passport Number',
                    _nicController,
                  ),
                  _buildInputField(
                    Icons.home,
                    'Address',
                    _addressController,
                  ),
                  _buildInputField(
                    Icons.cake,
                    'Birthday',
                    _birthdayController,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_validateInputFields()) {
                        userData.updateData(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          nic: _nicController.text.trim(),
                          address: _addressController.text.trim(),
                          birthday: _birthdayController.text.trim(),
                        );
                        Navigator.pushNamed(context, '/familydetails');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all the fields and provide valid information.'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validateInputFields() {
    return _nameController.text.isNotEmpty &&
        (_emailController.text.isNotEmpty &&
            EmailValidator.validate(_emailController.text)) &&
        _nicController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _birthdayController.text.isNotEmpty;
  }

  Widget _buildInputField(
      IconData icon,
      String labelText,
      TextEditingController controller, {
        String? Function(String?)? validator, // Optional validator function
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ), // Box effect with rounded corners
        ),
        validator: validator, // optional validation
      ),
    );
  }
}

