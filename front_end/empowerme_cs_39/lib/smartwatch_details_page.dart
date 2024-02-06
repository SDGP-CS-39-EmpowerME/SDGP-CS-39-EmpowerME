import 'package:empowerme_cs_39/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
/*import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth.dart';*/




class SmartwatchDetails extends StatefulWidget {
  const SmartwatchDetails({super.key});

   //MyApp({super.key});   
   @override
     // ignore: library_private_types_in_public_api
     State<SmartwatchDetails> createState() => _SmartwatchDetailsPageState();
}


class _SmartwatchDetailsPageState extends State<SmartwatchDetails> {
  String userName = "User_213";
  String deviceName = "Samsung";
  String connectedStatus = "Connected";

  //keeps track of current page to display
  int selectedIndex = 0;
  void navigateBottomBar(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    updateDeviceInfo();
  }


  void updateDeviceInfo() {
    setState(() {
      if (checkDeviceConnectionStatus()) {
        // Replace these lines with the actual logic to fetch user and device details
        userName = "User@123";
        deviceName = "Samsung";
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
    return/* MaterialApp(
      debugShowCheckedModeBanner: false,
      home:*/ Scaffold(
      
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Handlheige back navigation here
                },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: const Icon(
                  Icons.arrow_back_ios, // Replace this with your custom icon
                  color: Colors.white,
                  
                  ),
                  ),
                  ),


            backgroundColor: const Color.fromRGBO(0, 153, 255, 1),
            /*title: Transform.translate(
              offset: const Offset(-35, 18),
              child: const Text(*/
              title: const Text(
                "Smartwatch Details",
                style: TextStyle(
                  fontSize: 27,
                  color: Color.fromARGB(113, 57, 37, 236),
                  fontWeight: FontWeight.w800,
                ),
              ),
            //),
            actions: <Widget>[
              IconButton(
                //icon: Image.asset('assets/smartwatch_icon.png'),
                icon: const Icon(Icons.watch_outlined),
                iconSize: 35,
                color: Colors.white,
                onPressed: () {
                  // ignore: avoid_print
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
                  color: const Color.fromARGB(136, 226, 213, 230),
                ),
                child: const Text(
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      color: Color.fromARGB(136, 226, 213, 230),
                    ),

                    child: Container(
                      alignment: Alignment.centerRight,
                    child: const Icon(
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      color: 
                      Color.fromARGB(136, 226, 213, 230),
                    ),

                    child:Container(
                      alignment: Alignment.centerRight,
                    child: const Icon(
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
                      margin:  const EdgeInsets.only(top: 90, left: 20),
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.05,
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(136, 226, 213, 230),
                        ),

                      child: 
                      connectedStatus == " Connected" ?
                      const Icon(
                        Icons.link, size: 40,
                      color: Color.fromARGB(255, 0, 0, 0),)
                      :
                      const Icon(
                        Icons.link_off, size: 40,
                      color: Color.fromRGBO(63, 63, 63, 0.8),),
                /*child: Icon(
                  Icons.link,     //Icons.link_off,
                  size: 40,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),*/
              ),
                  ),
                  
                  TextSpan(
                    
                    text: connectedStatus, 
                    style: const TextStyle(
                      
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
        bottomNavigationBar: BottomNavBar(
          onTap: (index) => navigateBottomBar(index),
        ),
      );
    //);
  }

 

  // ignore: non_constant_identifier_names
  Container user_name(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 70, left: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
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
          style: const TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        )
        
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container device_details(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 50, left: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
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
          style: const TextStyle(
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
