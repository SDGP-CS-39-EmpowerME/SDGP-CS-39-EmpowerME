import 'package:flutter/material.dart';

class RegisterPassword extends StatefulWidget {
  const RegisterPassword({Key? key}) : super(key: key);

  @override
  State<RegisterPassword> createState() => _RegisterPasswordState();
}

bool agree = false;

class _RegisterPasswordState extends State<RegisterPassword> {
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
    String password = '';
    String confirmPassword = '';

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
            'Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildInputField(Icons.lock, "Password", (value) {
            password = value;
          }),
          _buildInputField(Icons.lock, "Confirm Password", (value) {
            confirmPassword = value;
          }),
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
                      fontSize: 14, // Adjust the font size as needed
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color, // Use the default text color
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: "Terms and Conditions",
                        style: TextStyle(
                          fontSize: 14, // Adjust the font size as needed
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
              if (password.isEmpty || confirmPassword.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all the fields.'),
                  ),
                );
              } else if (password != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match.'),
                  ),
                );
              } else if (!agree) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please agree to the terms and conditions.'),
                  ),
                );
              } else {
                // Perform registration logic here
                // Registration logic goes here
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Register'),
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
        obscureText: true,
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
