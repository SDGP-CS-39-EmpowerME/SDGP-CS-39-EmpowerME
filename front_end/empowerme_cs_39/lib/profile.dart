import 'package:empowerme_cs_39/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileDetailsPage(),
    );
  }
}

class ProfileDetailsPage extends StatefulWidget {
  @override
  _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  bool signedOut = false;

  Future<void> signOut() async {
    try {
      await auth.signOut();
      print('Successfully signed out');
      signedOut = true;
    } on FirebaseAuthException catch (e) {
      print('Sign-out failed: ${e.message}');
    }
  }
  // Permanent profile details
  String name = 'User_008';
  String birthday = '01/01/1990';
  String phoneNumber = '0712345678';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjusts the screen when the keyboard appears
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        shape: CustomShapeBorder(),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle, size: 50),
                const SizedBox(height: 10),
                profileField(Icons.person, 'Name', name),
                const SizedBox(height: 10),
                profileField(Icons.cake, 'Birthday', birthday),
                const SizedBox(height: 10),
                profileField(Icons.phone, 'Phone Number', phoneNumber),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          name: name,
                          birthday: birthday,
                          phoneNumber: phoneNumber,
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightBlue),
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signOut();
                    //if (!context.mounted) return;
                    //Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    if (signedOut == true){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(const Color.fromRGBO(255,255,255,100)),
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text(
                    '    Sign out    ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileField(IconData icon, String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.1, // Adjusted height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200], // Light gray color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold, // Make the text bold
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final String birthday;
  final String phoneNumber;

  const EditProfilePage({
    required this.name,
    required this.birthday,
    required this.phoneNumber,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _birthdayController;
  late TextEditingController _phoneNumberController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _birthdayController = TextEditingController(text: widget.birthday);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        shape: CustomShapeBorder(),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                profileInputField(
                  Icons.person,
                  'Name',
                  _nameController,
                ),
                const SizedBox(height: 20),
                profileInputField(
                  Icons.cake,
                  'Birthday',
                  _birthdayController,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _birthdayController.text =
                        "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                profileInputField(
                  Icons.phone,
                  'Phone Number',
                  _phoneNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10 digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save updated details here
                      String updatedName = _nameController.text;
                      String updatedBirthday = _birthdayController.text;
                      String updatedPhoneNumber = _phoneNumberController.text;

                      // Process the form data, such as saving it to a database
                      // For demonstration, we'll just print it
                      print('Updated Name: $updatedName');
                      print('Updated Birthday: $updatedBirthday');
                      print('Updated Phone Number: $updatedPhoneNumber');

                      // Show a snackbar message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Details saved successfully'),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightBlue),
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileInputField(
      IconData icon,
      String label,
      TextEditingController controller, {
        GestureTapCallback? onTap,
        String? Function(String?)? validator,
      }) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200], // Light gray color
      ),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: InputBorder.none,
        ),
        validator: validator,
        onTap: onTap,
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