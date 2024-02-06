import 'package:empowerme_cs_39/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class SavedFilesPage extends StatefulWidget {
  const SavedFilesPage({super.key});

  @override
  State<SavedFilesPage> createState() => _SavedFilesPageState();
}

class _SavedFilesPageState extends State<SavedFilesPage> {

  List <String> savedFilesMenu = ['Audio','D&T Records','Movement Records','BPM Records'];
  List <String> menuImages = ['assets/images-savedfiles/audio.png','assets/images-savedfiles/dateandtime.png','assets/images-savedfiles/movement.png','assets/images-savedfiles/heartrate.png'];

  //keeps track of current page to display
  int selectedIndex = 0;
  void navigateBottomBar(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  emergencyCall(){} //method for the emergency call button in the app bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Saved Files"),
        titleTextStyle: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: Color.fromRGBO(0, 124, 207, 1.0),
        ),
        backgroundColor: const Color.fromRGBO(0, 153, 255, 1.0),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 50, right: 50, bottom: 50),
        child: Center(
          child: GridView.builder(
            itemCount: savedFilesMenu.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
            ),
            itemBuilder: (context, index) {
              final word = savedFilesMenu[index];
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
                    // Handle button tap for the specific word
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, // Make background transparent
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
                        top: 65, // Adjust vertical position as needed
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
