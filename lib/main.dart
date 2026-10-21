import 'package:flutter/material.dart';
import 'package:wather_app/weather_page.dart';
import 'package:wather_app/welcome_page.dart';


void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(
        nextPage: MyWeatherPage(),
      ),
    );
  }
}