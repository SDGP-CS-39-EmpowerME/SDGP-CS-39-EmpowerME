
// ignore_for_file: unnecessary_new
import 'package:flutter/material.dart';
import 'package:empowerme_cs_39/home_page.dart';
import 'package:empowerme_cs_39/saved_files.dart';
import 'package:empowerme_cs_39/smartwatch_details_page.dart';

void main() {
runApp(MaterialApp(
  title: 'EmpowerMe App',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      useMaterial3:true,
      ),
  home: HomePage(), //specify the screen the app starts on.
  routes: <String, WidgetBuilder>{
    '/smartwatch_details_page': (BuildContext context) => SmartwatchDetails(),
    '/homepage' :(BuildContext context) =>  HomePage(),
    '/savedfilespage' :(BuildContext context) => SavedFilesPage(),
  },
));
}