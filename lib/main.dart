import 'package:flutter/material.dart';
import 'package:uas_mobile/create_page.dart';
import 'package:uas_mobile/home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/insertData': (context) => CreatePage()
    },
  ));
}
