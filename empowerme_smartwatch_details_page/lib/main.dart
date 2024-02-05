// ignore_for_file: prefer_const_constructors, unnecessary_string_escapes, avoid_print, sort_child_properties_last, unused_import, deprecated_member_use, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
/*import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth.dart';*/


void main() {
  runApp( MyApp());
}




class MyApp extends StatefulWidget {
   //MyApp({super.key});   
   _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  String userName = "User_213";
  String deviceName = "Samsung";
  String connectedStatus = "Connected";

  void initState() {
    super.initState();
    updateDeviceInfo();
  }


  void updateDeviceInfo() {
    setState(() {
      if (checkDeviceConnectionStatus()) {
        // Replace these lines with the actual logic to fetch user and device details
        userName = "User@123";
        deviceName = "Snmsung";
        connectedStatus = " Connected";
        
      } else {
        userName = "No user";
        deviceName = "No device";
        connectedStatus = " Not connected";
      }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: AppBar(
            backgroundColor: Color.fromRGBO(0, 153, 255, 1),
            title: Transform.translate(
              offset: const Offset(5.0, 17),
              child: Text(
                "Smartwatch Details",
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(113, 57, 37, 236),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                //icon: Image.asset('assets/smartwatch_icon.png'),
                icon: Icon(Icons.watch_outlined),
                iconSize: 40,
                color: Colors.black,
                onPressed: () {
                  print('Icon button pressed');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SecondPage()),
                  // );
                },
              ),
            ],
          ),
        ),

        
        
        body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 50, left: 0),
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.08,

              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromARGB(136, 226, 213, 230),
                ),
                child: Text(
                  "Device Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(175, 63, 133, 231),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 70, left: 58),
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      color: Color.fromARGB(136, 226, 213, 230),
                    ),

                    child: Container(
                      alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    )
                  ),
                ),

                Container(
                  child: user_name(context),
                )
              ],
            ),



            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 58),
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      color: 
                      Color.fromARGB(136, 226, 213, 230),
                    ),

                    child:Container(
                      alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.watch,
                      size: 50,
                      color: Color.fromARGB(255, 0, 0, 0),
                      
                      
                    ),
                    )
                  ),
                ),

                Container(
                  child: device_details(context),
                )
                
              ],
            ),


            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child:Container(
                      padding: EdgeInsets.zero,
                      margin:  EdgeInsets.only(top: 90, left: 20),
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.05,
                      alignment: Alignment.center,

                      child: 
                      connectedStatus == " Connected" ?
                      Icon(
                        Icons.link, size: 40,
                      color: Color.fromARGB(255, 0, 0, 0),)
                      :
                      Icon(
                        Icons.link_off, size: 40,
                      color: Color.fromRGBO(63, 63, 63, 0.8),),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(136, 226, 213, 230),
                        ),
                /*child: Icon(
                  Icons.link,     //Icons.link_off,
                  size: 40,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),*/
              ),
                  ),
                  
                  TextSpan(
                    
                    text: connectedStatus, 
                    style: TextStyle(
                      
                      fontSize: 30,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
            )
            )
            





          ],
          
        ),
      ),
    );
  }

 

  Container user_name(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 70, left: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
          color: Color.fromARGB(136, 226, 213, 230),
        ),
        
        child: Center(
        child: Text(
          userName,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        )
        
      ),
    );
  }

  Container device_details(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
          color: Color.fromARGB(136, 226, 213, 230),
        ),

        child:Center(
        child: Text(
          deviceName,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      )
      ),
    );
  }

  bool checkDeviceConnectionStatus() {
    // Replace this with the actual logic to check the device connection status
    // Return true if connected, false otherwise
    return true;
  }

}
