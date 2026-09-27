import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const kTitleTextStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.2,
);

class myWeatherPage extends StatefulWidget {
  const myWeatherPage({super.key});

  @override
  State<myWeatherPage> createState() => _myWeatherPageState();
}

class _myWeatherPageState extends State<myWeatherPage>
    with SingleTickerProviderStateMixin {
  TextEditingController locationController = TextEditingController();

  // Search weather data
  String city = "";
  String temperature = "";
  String weather = "";
  String humidity = "";
  String windSpeed = "";
  String visibility = "";
  String feelsLike = "";
  String sunrise = "";
  String sunset = "";

  // Current location weather data
  String currentCity = "";
  String currentTemp = "";
  String currentWeather = "";
  String currentHumidity = "";
  String currentWind = "";
  String currentFeelsLike = "";
  String currentSunrise = "";
  String currentSunset = "";

  bool isLoadingCurrent = true;
  bool isLoadingSearch = false;
  bool hasSearchResult = false;

  final String apikey = "ae2352b63c362802f1c515003d24fa81";

  // Weather emoji mapping
  String getWeatherEmoji(String condition) {
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

  // Dynamic background gradient based on weather
  List<Color> getWeatherColors(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [Color(0xFF1E90FF), Color(0xFF87CEEB)];
      case 'clouds':
        return [Color(0xFF607D8B), Color(0xFFB0BEC5)];
      case 'rain':
      case 'drizzle':
        return [Color(0xFF37474F), Color(0xFF546E7A)];
      case 'thunderstorm':
        return [Color(0xFF212121), Color(0xFF424242)];
      case 'snow':
        return [Color(0xFF90CAF9), Color(0xFFE3F2FD)];
      case 'mist':
      case 'fog':
      case 'haze':
        return [Color(0xFF78909C), Color(0xFFB0BEC5)];
      default:
        return [Color(0xFF42A5F5), Color(0xFF90CAF9)];
    }
  }

  // Convert unix timestamp to time string
  String unixToTime(int unix) {
    final dt =
        DateTime.fromMillisecondsSinceEpoch(unix * 1000, isUtc: false).toLocal();
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return "$hour:$min";
  }

  // Get Weather By Search
  Future<void> getWeather() async {
    if (locationController.text.trim().isEmpty) {
      myDialog(context, "Write your Country!");
      return;
    }

    setState(() {
      isLoadingSearch = true;
      hasSearchResult = false;
    });

    String location = locationController.text.trim();
    var url =
        "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apikey&units=metric";

    try {
      var res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          city = data['name'] + ", " + data['sys']['country'];
          temperature = data['main']['temp'].toStringAsFixed(1);
          weather = data['weather'][0]['main'];
          humidity = data['main']['humidity'].toString();
          windSpeed = data['wind']['speed'].toStringAsFixed(1);
          visibility = ((data['visibility'] ?? 0) / 1000).toStringAsFixed(1);
          feelsLike = data['main']['feels_like'].toStringAsFixed(1);
          sunrise = unixToTime(data['sys']['sunrise']);
          sunset = unixToTime(data['sys']['sunset']);
          isLoadingSearch = false;
          hasSearchResult = true;
        });
      } else if (res.statusCode == 404) {
        setState(() => isLoadingSearch = false);
        myDialog(context, "Not Found your Desteny ..Please Write Right Destany");
      } else {
        setState(() => isLoadingSearch = false);
        myDialog(context, "Something is Wrong ...Please Try Again And again");
      }
    } catch (e) {
      setState(() => isLoadingSearch = false);
      myDialog(context, "Chek internet।");
    }

    locationController.clear();
  }

  // Get Current Location Weather
  Future<void> getCurrentWeather() async {
    setState(() => isLoadingCurrent = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => isLoadingCurrent = false);
        myDialog(context, "Location permission denied. Settings থেকে চালু করুন।");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double lon = position.longitude;

      final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apikey&units=metric",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          currentCity = data["name"] + ", " + data['sys']['country'];
          currentTemp = data["main"]["temp"].toStringAsFixed(1);
          currentWeather = data["weather"][0]["main"];
          currentHumidity = data["main"]["humidity"].toString();
          currentWind = data["wind"]["speed"].toStringAsFixed(1);
          currentFeelsLike = data["main"]["feels_like"].toStringAsFixed(1);
          currentSunrise = unixToTime(data['sys']['sunrise']);
          currentSunset = unixToTime(data['sys']['sunset']);
          isLoadingCurrent = false;
        });
      }
    } catch (e) {
      setState(() => isLoadingCurrent = false);
      myDialog(context, "There is Something Probleb to Find Your Location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> bgColors = currentWeather.isNotEmpty
        ? getWeatherColors(currentWeather)
        : [Color(0xFF1E90FF), Color(0xFF87CEEB)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: getCurrentWeather,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Center(
                    child: Text(
                      " Weather App",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Center(
                    child: Text(
                      "Pull down to refresh current location",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ── Current Location Card ──
                  _sectionLabel("Your Current Location"),
                  SizedBox(height: 8),
                  isLoadingCurrent
                      ? _loadingCard()
                      : currentCity.isEmpty
                          ? _errorCard("Location not find")
                          : _weatherCard(
                              cityName: currentCity,
                              temp: currentTemp,
                              condition: currentWeather,
                              humidity: currentHumidity,
                              wind: currentWind,
                              feelsLike: currentFeelsLike,
                              sunrise: currentSunrise,
                              sunset: currentSunset,
                            ),

                  SizedBox(height: 28),

                  // ── Search Section ──
                  _sectionLabel("Find City Or Town"),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: TextField(
                      controller: locationController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter City Or Town",
                        hintStyle: TextStyle(color: Colors.white60),
                        prefixIcon:
                            Icon(Icons.location_city, color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (_) => getWeather(),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: isLoadingSearch ? null : getWeather,
                      icon: isLoadingSearch
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.search),
                      label: Text(
                        isLoadingSearch ? "Finding..." : "See weather",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: bgColors[0],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ── Search Result ──
                  if (hasSearchResult) ...[
                    _sectionLabel("The Ans"),
                    SizedBox(height: 8),
                    _weatherCard(
                      cityName: city,
                      temp: temperature,
                      condition: weather,
                      humidity: humidity,
                      wind: windSpeed,
                      feelsLike: feelsLike,
                      sunrise: sunrise,
                      sunset: sunset,
                    ),
                  ] else if (!isLoadingSearch) ...[
                    Center(
                      child: Text(
                        "Upore sohorer nam likhe sarch koro",
                        style: TextStyle(
                            color: Colors.white60,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Section Label ──
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  // ── Loading Card ──
  Widget _loadingCard() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 12),
            Text("Location Finding..",
                style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // ── Error Card ──
  Widget _errorCard(String msg) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Center(
        child: Text(msg,
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  // ── Weather Info Card ──
  Widget _weatherCard({
    required String cityName,
    required String temp,
    required String condition,
    required String humidity,
    required String wind,
    required String feelsLike,
    required String sunrise,
    required String sunset,
  }) {
    String emoji = getWeatherEmoji(condition);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City + Emoji + Temp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      condition,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(emoji, style: TextStyle(fontSize: 42)),
                  Text(
                    "$temp°C",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16),
          Divider(color: Colors.white30),
          SizedBox(height: 12),

          // Info Row 1: Humidity + Wind + Feels Like
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoTile("💧", "Humidity", "$humidity%"),
              _infoTile("💨", "Wind", "$wind m/s"),
              _infoTile("🌡️", "Feels Like", "$feelsLike°C"),
            ],
          ),

          SizedBox(height: 12),

          // Info Row 2: Sunrise + Sunset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoTile("🌅", "Sunrise", sunrise),
              _infoTile("🌇", "Sunset", sunset),
            ],
          ),
        ],
      ),
    );
  }

  // ── Single Info Tile ──
  Widget _infoTile(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 22)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Dialog ──
Future<dynamic> myDialog(BuildContext context, String msg) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          msg,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ok",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    },
  );
}