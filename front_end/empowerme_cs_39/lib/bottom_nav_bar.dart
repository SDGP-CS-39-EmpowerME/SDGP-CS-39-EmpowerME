import 'package:flutter/material.dart';
import 'package:empowerme_cs_39/profile.dart';

import 'home_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.onTap});

  final Function onTap; // Define the onTap function as a property

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0; // Define selectedIndex for tracking the selected item
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10, // Adjust blur radius for desired softness
            offset: const Offset(0, -2), // Apply shadow above the bar
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 10, // Add elevation for visual separation
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 0){
            setState(() {
              selectedIndex = index;
              widget.onTap(index);
            });
            //Navigator.pushNamed(context, '/homepage');
            try{
            Navigator.pushReplacementNamed(context, '/homepage');
            } catch (e) {
              print(e);
            }
          }
          else if (index == 1) { // Check if tapped index is 1 (Detect)
            setState(() {
              _isPlaying = !_isPlaying; // Toggle play/pause state
              widget.onTap(index); // Call provided function
            });
          }
          else if (index == 2) {
            setState(() {
              selectedIndex = index;
              widget.onTap(index);
            });
            try{
              /*Navigator.pushReplacementNamed(context, '/profilepage');*/
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } catch (e) {
              print(e);
            }
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 40, color: selectedIndex == 0 ? Colors.blue : Colors.grey,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 30),
                child: _isPlaying ? const Icon(Icons.pause_rounded, size: 40) : const Icon(Icons.play_arrow_rounded, size: 40),
            ),
            label: 'Detect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded, size: 40, color: selectedIndex == 2 ? Colors.blue : Colors.grey,),
            label: 'Profile',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );

  }
}
