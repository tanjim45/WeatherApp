import 'package:flutter/material.dart';

class WeatherHelper {
  // Weather condition -> emoji
  static String getWeatherEmoji(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
      case 'haze':
        return '🌫️';
      case 'smoke':
        return '💨';
      case 'dust':
      case 'sand':
        return '🌪️';
      default:
        return '🌤️';
    }
  }

  // Weather condition -> background gradient colors
  static List<Color> getWeatherColors(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF1E90FF), const Color(0xFF87CEEB)];
      case 'clouds':
        return [const Color(0xFF607D8B), const Color(0xFFB0BEC5)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF37474F), const Color(0xFF546E7A)];
      case 'thunderstorm':
        return [const Color(0xFF212121), const Color(0xFF424242)];
      case 'snow':
        return [const Color(0xFF90CAF9), const Color(0xFFE3F2FD)];
      case 'mist':
      case 'fog':
      case 'haze':
        return [const Color(0xFF78909C), const Color(0xFFB0BEC5)];
      default:
        return [const Color(0xFF42A5F5), const Color(0xFF90CAF9)];
    }
  }

  // Unix timestamp -> "HH:mm" local time string
  static String unixToTime(int unix) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000, isUtc: false)
        .toLocal();
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return "$hour:$min";
  }
}
