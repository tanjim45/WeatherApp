import 'package:flutter/material.dart';
import 'package:wather_app/weather_page.dart';

void main() {
  runApp(weatherApp());
}

class weatherApp extends StatelessWidget {
  const weatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWeatherPage(),
    );
  }
}
