
// ignore_for_file: unnecessary_new
import 'package:flutter/material.dart';
import 'package:empowerme_cs_39/smartwatch_details_page.dart';

void main() {
runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: new SmartwatchDetails(), //specify the screen the app starts on.
  routes: <String, WidgetBuilder>{
    '/smartwatch_details_page': (BuildContext context) => SmartwatchDetails(),
  },
));
}