import 'package:empowerme_cs_39/files_and_coords.dart';
import 'package:empowerme_cs_39/navbar_detection.dart';
import 'package:flutter/material.dart';
import 'package:empowerme_cs_39/profile.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


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
  String fileName = ''; //from DetectionService
  FilesCoordinates filesCoordinates = FilesCoordinates();
  Map <String, String> fileCoords = {};
  Timer? _timer;
  late String lat;
  late String long;
  late String locationCoords;
  bool locationChange = false;

  @override
  void initState() {
    super.initState();
    detect = DetectionService();
    fileCoords = filesCoordinates.fileCoordinates;
  }

  @override
  void dispose() {
    //detect.recorder.closeRecorder();
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

  Future stopThing(FlutterBackgroundService service) async {
    stopRecording();
    detect.stopRecorder();
    _showSnackBar(
      const SnackBar(
        backgroundColor: Colors.blue,
        content: Text('Recording stopped.'),
        duration: Duration(milliseconds: 1000),
      ),
    );
    /*service.invoke('setAsBackground');*/
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        elevation: 20, // Add elevation for visual separation
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
            final service = FlutterBackgroundService();
            if (isConnected == ConnectivityResult.mobile || isConnected == ConnectivityResult.wifi) {
              setState(() {
                _isPlaying = !_isPlaying; // Toggle play/pause state
                widget.onTap(index); // Call provided function
              });
              if (_isPlaying) {
                try{
                  service.invoke('setAsForeground');
                  PermissionStatus microphoneStatus = await Permission.microphone.request();
                  //PermissionStatus locationStatus = await Permission.locationWhenInUse.request();
                  LocationPermission location = await Geolocator.requestPermission();
                  location = await Geolocator.checkPermission();
                  PermissionStatus storageStatus = await Permission.manageExternalStorage.request();

                  if (microphoneStatus == PermissionStatus.granted && /*locationStatus*/location == LocationPermission.always && storageStatus == PermissionStatus.granted && !detect.recorder.isRecording) {
                    _showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('Grabbing location data...'),
                        duration: Duration(milliseconds: 400),
                      ),
                    );
                    await _getCurrentLocation().then((value){
                      lat = '${value.latitude}';
                      long = '${value.longitude}';
                      setState(() {
                        locationCoords = '$lat°,$long°';
                      });
                      print("L   O   C   A   T   I   O   N   --->  $locationCoords");
                      _liveLocation(service);
                    });
                    await detect.startRecording();
                    _showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('Recording started.'),
                        duration: Duration(milliseconds: 1000),
                      ),
                    );
                    // Starts a recurring timer that stops and restarts the recording every 30 seconds
                    _timer = Timer.periodic(const Duration(seconds: 15), (Timer t) async {
                          onRecordButtonTapped(); //Adds the filename and coordinates to the SharedPreferences instance
                          await detect.stopRecorder();
                          /*await _getCurrentLocation().then((value){
                            lat = '${value.latitude}';
                            long = '${value.longitude}';
                            setState(() {
                              locationCoords = '$lat°,$long°';
                            });
                            print("L   O   C   A   T   I   O   N   --->  $locationCoords");
                            _liveLocation(service);
                          });*/
                          await detect.startRecording();
                          _showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Recording restarted.'),
                              duration: Duration(milliseconds: 1000),
                            ),
                          );
                        });
                  }

                  else {
                    if (microphoneStatus == PermissionStatus.denied || location == LocationPermission.denied || storageStatus == PermissionStatus.denied){
                      _showSnackBar(const SnackBar(
                        backgroundColor: Colors.black45,
                        content: Text('Permission is necessary for detection.'),
                      ));
                      setState(() {
                        _isPlaying = false;
                      });
                    }
                    else if (microphoneStatus == PermissionStatus.permanentlyDenied || location == LocationPermission.deniedForever || storageStatus == PermissionStatus.permanentlyDenied){
                      setState(() {
                        _isPlaying = false;
                      });
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
              } else if (!_isPlaying){
                await stopThing(service);
                service.invoke('stopService');
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

  String getLocation(){
    return locationCoords;
  }

  /// every time the button is pressed and the file names and the coords are obtained, the key-value pair should be formed.
  /// The instance should be the same thing for all pairs and the instance should be created only once. Change below code to make that happen. meka me nikan liyala thiyenne.
  void onRecordButtonTapped() async {
    fileName = await detect.getFileName();
    //Starts a SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    //Stores the coordinates with the file name as the key
    await prefs.setString(fileName,locationCoords);
  }

  //listen to location settings
  void _liveLocation(FlutterBackgroundService service) {
    service.invoke('setAsForeground');
    LocationSettings locSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 30,
    );
    Geolocator.getPositionStream(locationSettings: locSettings)
      .listen((Position position) {
        /*lat = position.latitude.toString();
        long = position.longitude.toString();*/
      locationChange = true;
    });
  }

  Future <Position> _getCurrentLocation() async {
    try{
      return await Geolocator.getCurrentPosition();
    } catch (e){
      return Future.error(e);
    }
  }
}