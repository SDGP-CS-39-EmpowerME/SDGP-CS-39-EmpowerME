import 'package:flutter/material.dart';
class RegisterFamilyDetails extends StatelessWidget {
  const RegisterFamilyDetails({Key? key}) : super(key: key);

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

    String personName = "";
    String personBirthday = "";
    String personPhone = "";
    String familyMemberCount = "";
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
          _buildInputField(Icons.person, "Person's Name" , (value){
            personName = value;
          }),
          _buildInputField(Icons.cake, "Person' Birthday" , (value){
            personBirthday = value;
          }),
          _buildInputField(Icons.phone, "Person' s Phone Number" , (value){
            personPhone = value;
          }),
          _buildInputField(Icons.people, "Family member's Count" , (value){
            familyMemberCount = value;
          }),
          ElevatedButton(
            onPressed: () {
              if(personName.isEmpty ||
                  personBirthday.isEmpty ||
                  personPhone.isEmpty ||
                  familyMemberCount.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all the fields.'),
                  )
                );
              } else{
                 Navigator.pushNamed(context, '/password');
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

  Widget _buildInputField(IconData icon, String labelText, Function(String) value) {
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
