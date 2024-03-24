import 'package:empowerme_cs_39/bottom_nav_bar.dart';
import 'package:empowerme_cs_39/cloud_storage.dart';
import 'package:empowerme_cs_39/new_saved_files.dart';
import 'package:empowerme_cs_39/recorder_page.dart';
import 'package:empowerme_cs_39/saved_files.dart';
import 'package:empowerme_cs_39/smartwatch_details_page.dart';
import 'package:empowerme_cs_39/manual_upload.dart';
import 'package:empowerme_cs_39/voice_recorder_page.dart';
import 'package:flutter/material.dart';
import 'package:empowerme_cs_39/auth/auth_bool.dart';
import 'auth/auth_bool.dart';
import 'emergency_contacts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List <String> menuImages = ['assets/images-home/record.png','assets/images-home/watch.png','assets/images-home/savedfiles.png','assets/images-home/upload.png','assets/images-home/settings.png','assets/images-home/cloud.png'];
  List <String> mainMenu = ['Record','Watch','Saved Files', 'Upload','Settings','Cloud'];
  AuthBool authBool = AuthBool();
  //keeps track of current page to display
  int selectedIndex = 0;
  void navigateBottomBar(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  emergencyCall(){} //method for the emergency call button in the app bar

  void menuPressed(int index) {
    switch (index){
      case 0:
        //code for record page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VoiceRecorderPage2()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SmartwatchDetails()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SavedFilesNew()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManualUpload()),
        );
        break;
      case 4:
        //code for settings page
        break;
      case 5:
        print(authBool.loginAsGuest);
        if (authBool.loginAsGuest == false){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CloudStorage()),
          );
        } else if (authBool.loginAsGuest == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Guest Access'),
                content: Text('You are logged in as a guest.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        break;
    }
  }
  void EmergencyPage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage()),
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white/*grey[200]*/,
      appBar: PreferredSize(
        preferredSize:const Size.fromHeight(75.0),
        child: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          /*fontWeight: FontWeight.w800,*/
          color: Colors.white,
        ),
        backgroundColor: const Color.fromRGBO(0, 153, 255, 1.0),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.call,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => EmergencyPage(), // emergency page
          ),
        ],
              ),
    ),

      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 25, right: 25, bottom: 50),
        child: Center(
          child: GridView.builder(
            itemCount: mainMenu.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              final word = mainMenu[index];
              final image = menuImages[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Button's background color
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 5, // Adjust blur radius as needed
                      offset: const Offset(0, 3), // Adjust offset for shadow position
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // if index is pressed, goes to switch-case.
                    menuPressed(index);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Make background transparent
                    elevation: 0, // Remove default elevation
                    padding: const EdgeInsets.all(10), // Button's internal padding
                  ),
                  child: Stack(
                    children: [
                      // Position text at top left
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          word,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ),
                        ),
                      ),
                      // Position image within the button container
                      Positioned(
                        top: 60, // Adjust vertical position as needed
                        left: 60, // Adjust horizontal position as needed
                        child: Image.asset(
                          image,
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        onTap: (index) => navigateBottomBar(index),
      ),

    );
  }

}
