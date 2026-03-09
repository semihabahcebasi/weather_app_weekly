import 'package:flutter/material.dart';
import 'package:weather_app_weekly/screens/home_page.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // DEBUG yazısını kaldırır

      home: HomePage(),
    );
  }
}
