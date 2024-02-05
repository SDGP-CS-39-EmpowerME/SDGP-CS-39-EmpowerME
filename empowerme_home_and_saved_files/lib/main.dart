import 'package:dinuka_empower_me/home_page.dart';
import 'package:dinuka_empower_me/saved_files.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home:HomePage(),
      routes:{
        '/homepage' :(context) =>  HomePage(),
        '/savedfilespage' :(context) => SavedFilesPage(),
      },
    );
  }
}