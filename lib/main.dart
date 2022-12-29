import 'package:flutter/material.dart';
import 'package:uas_mobile/home_page.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      // '/item': (context) => ItemPage(),
    },
  ));
}