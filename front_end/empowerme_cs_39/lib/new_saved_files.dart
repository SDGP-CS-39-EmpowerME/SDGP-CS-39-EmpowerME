import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bottom_nav_bar.dart';
import 'files_and_coords.dart';

Future<List<String>> getAudioFiles() async {
  final directory = (await getExternalStorageDirectory())!;
  var path = '${directory.path}/App Recordings';
  var dir = Directory(path);

  var files = await dir.listSync().where((file) => file is File).toList();
  files.sort((a, b) => a.statSync().modified.compareTo(b.statSync().modified)); //sorts using date modified (oldest to newest). Try with async if this isn't working properly.
  List<String> fileNames = files.map((file) => file.path.split('/').last).toList();
  return fileNames;
}

class SavedFilesNew extends StatefulWidget {
  @override
  _SavedFilesNewState createState() => _SavedFilesNewState();
}

class _SavedFilesNewState extends State<SavedFilesNew> {
  FilesCoordinates filesCoordinates = FilesCoordinates();
  Map <String, String> fileCoords = {};
  late List<String> items = [];
  late List<String> itemListDirectory = [];
  int selectedIndex = 3;
  void navigateBottomBar(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    items;
    loadFileNames();
    fileCoords = filesCoordinates.fileCoordinates;
  }

  Future <void> loadFiles() async {
    bool searchRemoveDone = false;
    print("About to load files");
    //get the SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    print("prefs instance");
    await searchAndRemove(prefs,searchRemoveDone);
    //Retrieve the coordinates for each file
    for (String fileName in itemListDirectory){
      String? coordinates = prefs.getString(fileName);
      print("coordinates: $coordinates");
      if (coordinates != null){
        fileCoords[fileName] = coordinates; //loads data to map
        print("data loaded to map");
      }
    }
    items = fileCoords.keys.toList();
    print(items);
  }

  Future<void> searchAndRemove(SharedPreferences prefs,bool searchRemoveDone) async {
    print("Inside search and remove method");
    Set<String> keysToRemove = {};
  // Checks each entry in SharedPreferences
    prefs.getKeys().forEach((key) {
      // If the key is not in itemListDirectory, its marked for removal
      if (!itemListDirectory.contains(key)) {
        keysToRemove.add(key);
        print("SaR: key added to temp list");
      }
    });
  // Removes the marked keys from SharedPreferences
    keysToRemove.forEach((key) {
      prefs.remove(key);
      print("key removed");
      searchRemoveDone = true;
    });

  }

  Future<void> loadFileNames() async {
    print("loadFileNames()");
    var status = await Permission.storage.status;
    print("statuschecked");
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    itemListDirectory = await getAudioFiles();
    print(itemListDirectory.length);
    print("files obtained");
    loadFiles();
    setState(() {}); // This is needed to trigger a rebuild of the widget after the data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:const Size.fromHeight(75.0),
          child: AppBar(
            title: const Text("Saved Files"),
            /*centerTitle: true,*/
            titleTextStyle: const TextStyle(
              fontSize: 30,
              /*fontWeight: FontWeight.w800,*/
              color: Colors.white,
            ),
            backgroundColor: const Color.fromRGBO(0, 153, 255, 1.0),
          ),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              subtitle: Text(fileCoords[items[index]] ?? 'No coordinates available'),
              trailing: IconButton(
                icon: Icon(Icons.map),
                /*onPressed: () async {
                  final coordinates = fileCoords[items[index]];
                  if (coordinates != null) {
                    final uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': coordinates});
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      throw 'Could not launch $uri';
                    }
                  }
                },*/
                onPressed: () async {
                  final coordinates = fileCoords[items[index]];
                  if (coordinates != null) {
                    final uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': coordinates});

                    // Check if the URL can be launched
                    final canLaunch = await canLaunchUrl(uri);
                    if (canLaunch) {
                      await launchUrl(uri);
                    } else {
                      print('Could not launch $uri');
                      // Handle the case where the URL cannot be launched (e.g., show an error message to the user)
                    }
                  }
                },
              ),
            );
          },
        ),

/*ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              subtitle: Text(DateTime.now().toString()),
              trailing: IconButton(
                icon: Icon(Icons.map),
                onPressed: () async {
                  final url = 'https://www.google.com/maps/search/?api=1&query=37.4220,-122.0841';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            );
          },
        ),*/
        bottomNavigationBar: BottomNavBar(
          onTap: (index) => navigateBottomBar(index),
        ),
      ),
    );
  }
}
