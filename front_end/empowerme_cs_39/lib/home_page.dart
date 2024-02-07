import 'package:empowerme_cs_39/bottom_nav_bar.dart';
import 'package:empowerme_cs_39/saved_files.dart';
import 'package:empowerme_cs_39/smartwatch_details_page.dart';
import 'package:empowerme_cs_39/manual_upload.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List <String> menuImages = ['assets/images-home/record.png','assets/images-home/watch.png','assets/images-home/savedfiles.png','assets/images-home/upload.png','assets/images-home/settings.png','assets/images-home/cloud.png'];
  List <String> mainMenu = ['Record','Watch','Saved Files', 'Upload','Settings','Cloud'];

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
          MaterialPageRoute(builder: (context) => SavedFilesPage()),
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
        //code for cloud page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize:const Size.fromHeight(75.0),
        child: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: Color.fromRGBO(0, 124, 207, 1.0),
        ),
        backgroundColor: const Color.fromRGBO(0, 153, 255, 1.0),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.call,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => emergencyCall(), // define onPressed logic here
          ),
        ],
      ),
    ),

      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 50, right: 50, bottom: 50),
        child: Center(
          child: GridView.builder(
            itemCount: mainMenu.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
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
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10, // Adjust blur radius as needed
                      offset: const Offset(2, 5), // Adjust offset for shadow position
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
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Position image within the button container
                      Positioned(
                        top: 50, // Adjust vertical position as needed
                        left: 50, // Adjust horizontal position as needed
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
