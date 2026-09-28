import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wather_app/weather_model.dart';


class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => message;
}

class WeatherService {
 
  static const String _apiKey = "ae2352b63c362802f1c515003d24fa81";
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<WeatherModel> fetchByCity(String city) async {
    final url = Uri.parse("$_baseUrl?q=$city&appid=$_apiKey&units=metric");

    final res = await http.get(url);

    if (res.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(res.body));
    } else if (res.statusCode == 404) {
      throw WeatherException(
          "Not Found your Destiny .. Please Write Right Destiny");
    } else {
      throw WeatherException("Something is Wrong ...Please Try Again");
    }
  }

  Future<WeatherModel> fetchByCoords(double lat, double lon) async {
    final url =
        Uri.parse("$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric");

    final res = await http.get(url);

    if (res.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(res.body));
    } else {
      throw WeatherException("Could not fetch weather for your location");
    }
  }
}
