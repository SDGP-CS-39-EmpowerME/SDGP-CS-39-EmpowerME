import 'package:empowerme_cs_39/auth/register_3_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:empowerme_cs_39/auth/register_userdata.dart';

class RegisterFamilyDetails extends StatefulWidget {
  const RegisterFamilyDetails({Key? key}) : super(key: key);

  @override
  State<RegisterFamilyDetails> createState() => _RegisterFamilyDetailsState();
}

class _RegisterFamilyDetailsState extends State<RegisterFamilyDetails> {
  final _personNameController = TextEditingController();
  final _personBirthdayController = TextEditingController();
  final _personPhoneController = TextEditingController();
  final _familyMemberCountController = TextEditingController();

  @override
  void dispose() {
    _personNameController.dispose();
    _personBirthdayController.dispose();
    _personPhoneController.dispose();
    _familyMemberCountController.dispose();
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
          child: _buildRegistrationContainer(context,userData),
        ),
      ),
    );
  }

  Widget _buildRegistrationContainer(BuildContext context, userData) {
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
            'Family Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildInputField(
            Icons.person,
            "Person's Name",
            _personNameController,
          ),
          _buildInputField(
            Icons.cake,
            "Person's Birthday",
            _personBirthdayController,
          ),
          _buildInputField(
            Icons.phone,
            "Person's Phone Number",
            _personPhoneController,
          ),
          _buildInputField(
            Icons.people,
            "Family Members' Count",
            _familyMemberCountController,
          ),
          ElevatedButton(
            onPressed: () {
              // Access values directly from controllers
              if (_validateInputFields()) {
                userData.updateData(
                  name: userData.name, // Retrieve data from existing user object
                  email: userData.email, // Retrieve data from existing user object
                  nic: userData.nic, // Retrieve data from existing user object
                  address: userData.address, // Retrieve data from existing user object
                  birthday: userData.birthday, // Retrieve data from existing user object
                  secondPersonName: _personNameController.text, // New information
                  secondPersonBirthday: _personBirthdayController.text, // New information
                  phone: _personPhoneController.text, // New information
                  familyCount: _familyMemberCountController.text, // New information
                );

                //Navigator.pushNamed(context, '/passwordpage');
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RegisterPassword()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all the fields and provide valid information.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  bool _validateInputFields() {
    return _personNameController.text.isNotEmpty &&
        _personBirthdayController.text.isNotEmpty &&
        _personPhoneController.text.isNotEmpty &&
        _familyMemberCountController.text.isNotEmpty;
  }

  Widget _buildInputField(IconData icon, String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
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
