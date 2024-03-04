/*

// ignore_for_file: unnecessary_new
import 'package:empowerme_cs_39/login.dart';
// ignore: unused_import
import 'package:empowerme_cs_39/register_1_personal.dart';
import 'package:empowerme_cs_39/register_3_password.dart';
import 'package:flutter/material.dart';
import 'package:empowerme_cs_39/home_page.dart';
import 'package:empowerme_cs_39/saved_files.dart';
import 'package:empowerme_cs_39/smartwatch_details_page.dart';
import 'package:empowerme_cs_39/voice_recorder_page.dart';
import 'package:empowerme_cs_39/connect_smartwatch.dart';
import 'package:empowerme_cs_39/profile.dart';
import 'package:empowerme_cs_39/register_2_family.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'EmpowerMe App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3:true,
    ),
    home: const login(), //specify the screen the app starts on.
    routes: <String, WidgetBuilder>{
      '/smartwatch_details_page': (BuildContext context) => const SmartwatchDetails(),
      '/homepage' : (BuildContext context) =>  const HomePage(),
      '/savedfilespage' : (BuildContext context) => const SavedFilesPage(),
      '/voicerecorderpage' : (BuildContext context) => const voiceRecorderPage(),
      '/connectsmartwatchpage' : (BuildContext context) => const Connect_smartwatch(),
      '/profilepage' : (BuildContext context) => const ProfilePage(),
      '/familydetails' : (BuildContext context) => const RegisterFamilyDetails(),
      '/passwordpage' : (BuildContext context) => const RegisterPassword(),
    },
  ));
}*/
import 'package:empowerme_cs_39/auth/login.dart';
import 'package:empowerme_cs_39/auth/main_auth_page.dart';
import 'package:empowerme_cs_39/auth/register_1_personal.dart';
import 'package:empowerme_cs_39/auth/register_3_password.dart';
import 'package:flutter/material.dart';
import 'package:empowerme_cs_39/home_page.dart';
import 'package:empowerme_cs_39/saved_files.dart';
import 'package:empowerme_cs_39/smartwatch_details_page.dart';
import 'package:empowerme_cs_39/voice_recorder_page.dart';
import 'package:empowerme_cs_39/connect_smartwatch.dart';
import 'package:empowerme_cs_39/profile.dart';
import 'package:empowerme_cs_39/auth/register_2_family.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_options.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:empowerme_cs_39/auth/register_userdata.dart'; // Import UserData class

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider( // Wrap app with MultiProvider
      providers: [
        ChangeNotifierProvider(create: (_) => UserData()), // Provide UserData
      ],
      child: MaterialApp(
        title: 'EmpowerMe App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        home: const MainAuthPage(),
        routes: <String, WidgetBuilder>{
          '/smartwatch_details_page': (BuildContext context) => const SmartwatchDetails(),
          '/homepage': (BuildContext context) => const HomePage(),
          '/savedfilespage': (BuildContext context) => const SavedFilesPage(),
          '/voicerecorderpage': (BuildContext context) => const voiceRecorderPage(),
          '/connectsmartwatchpage': (BuildContext context) => const Connect_smartwatch(),
          '/profilepage': (BuildContext context) => const ProfilePage(),
          '/familydetails': (BuildContext context) => const RegisterFamilyDetails(),
          '/passwordpage': (BuildContext context) => const RegisterPassword(),
          '/login': (BuildContext context) => Login(),
        },
      ),
    ),
  );
}
