import 'package:empowerme_cs_39/navbar_detection.dart';
import 'package:flutter/material.dart';
import 'package:empowerme_cs_39/profile.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.onTap});

  final Function onTap; // Define the onTap function as a property

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0; // Define selectedIndex for tracking the selected item
  bool _isPlaying = false;
  DetectionService detect = DetectionService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    detect = DetectionService();
  }

  @override
  void dispose() {
    detect.recorder.closeRecorder();
    //detect.recordSubscription?.cancel();
    super.dispose();
  }

  bool _isSnackBarVisible = false; // State variable to track SnackBar visibility
  void _showSnackBar(SnackBar snackBar) async {
    if (!_isSnackBarVisible) {
      _isSnackBarVisible = true;
      await Future.delayed(const Duration(milliseconds: 100)); // Short delay
      ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value) {
        _isSnackBarVisible = false;
      });
    }
  }

  Future stopRecording() async {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

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
        onTap: (index) async {
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

          else if (index == 1) {
            // Check for internet connectivity
            final isConnected = await Connectivity().checkConnectivity();
            if (isConnected == ConnectivityResult.mobile || isConnected == ConnectivityResult.wifi) {
              setState(() {
                _isPlaying = !_isPlaying; // Toggle play/pause state
                widget.onTap(index); // Call provided function
              });
              if (_isPlaying) {
                try{
                  PermissionStatus microphoneStatus = await Permission.microphone.request();
                  PermissionStatus locationStatus = await Permission.locationWhenInUse.request();
                  PermissionStatus storageStatus = await Permission.manageExternalStorage.request();

                  /*if (microphoneStatus == PermissionStatus.granted && locationStatus == PermissionStatus.granted && storageStatus == PermissionStatus.granted && !detect.recorder.isRecording) {
                    await detect.startRecording();
                    _showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('Recording started.'),
                      ),
                    );
                  }*/
                  if (microphoneStatus == PermissionStatus.granted && locationStatus == PermissionStatus.granted && storageStatus == PermissionStatus.granted && !detect.recorder.isRecording) {
                    await detect.startRecording();
                    _showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('Recording started.'),
                      ),
                    );

                    // Starts a recurring timer that stops and restarts the recording every 30 seconds
                    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
                          await detect.stopRecorder();
                          _showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Recording stopped.'),
                            ),
                          );

                          await detect.startRecording();
                          _showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Recording restarted.'),
                            ),
                          );
                        });
                  }

                  else {
                    if (microphoneStatus == PermissionStatus.denied || locationStatus == PermissionStatus.denied || storageStatus == PermissionStatus.denied){
                      _isPlaying = false;
                      _showSnackBar(const SnackBar(
                        backgroundColor: Colors.black45,
                        content: Text('Permission is necessary for detection.'),
                      ));
                    }
                    else if (microphoneStatus == PermissionStatus.permanentlyDenied || locationStatus == PermissionStatus.permanentlyDenied || storageStatus == PermissionStatus.permanentlyDenied){
                      _isPlaying = false;
                      openAppSettings();
                    }
                  }
                } catch (e) {
                  _showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Service is currently unavailable. Contact the developers.'),
                    ),
                  );
                }
              } else {
                stopRecording();
                detect.stopRecorder();
                _showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.blue,
                    content: Text('Recording stopped.'),
                  ),
                );
              }
            } else {
              _showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('No internet connection. Detection unavailable.'),
                ),
              );
            }
          }

          else if (index == 2) {
            setState(() {
              selectedIndex = index;
              widget.onTap(index);
            });
            try{
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
