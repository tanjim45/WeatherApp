import 'package:wather_app/weather_helper.dart';



class WeatherModel {
  final String city;
  final String condition;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final double visibilityKm;
  final String sunrise;
  final String sunset;

  WeatherModel({
    required this.city,
    required this.condition,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.visibilityKm,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      
      city: "${json['name']}, ${json['sys']['country']}",
      condition: json['weather'][0]['main'],
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      visibilityKm: ((json['visibility'] ?? 0) as num) / 1000,
      sunrise: WeatherHelper.unixToTime(json['sys']['sunrise']),
      sunset: WeatherHelper.unixToTime(json['sys']['sunset']),
    );
  }
}
