import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:empowerme_cs_39/home_page.dart';
import 'package:empowerme_cs_39/auth/login.dart';

class MainAuthPage extends StatelessWidget {
  const MainAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.hasData){

            return HomePage();
          } else {
            return Login();
          }
        }
      ),
    );
  }
}