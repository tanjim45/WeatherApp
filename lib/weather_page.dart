import 'package:flutter/material.dart';
import 'package:wather_app/error_card.dart';
import 'package:wather_app/loading_card.dart';
import 'package:wather_app/location_service.dart';
import 'package:wather_app/my_dialog.dart';
import 'package:wather_app/weather_card.dart';
import 'package:wather_app/weather_helper.dart';
import 'package:wather_app/weather_model.dart';
import 'package:wather_app/weather_service.dart';



class MyWeatherPage extends StatefulWidget {
  const MyWeatherPage({super.key});

  @override
  State<MyWeatherPage> createState() => _MyWeatherPageState();
}

class _MyWeatherPageState extends State<MyWeatherPage> {
  final TextEditingController locationController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  WeatherModel? searchedWeather;
  WeatherModel? currentWeather;

  bool isLoadingCurrent = true;
  bool isLoadingSearch = false;
  bool hasSearchResult = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentWeather();
  }

  Future<void> _loadCurrentWeather() async {
    setState(() => isLoadingCurrent = true);

    try {
      final position = await _locationService.getCurrentPosition();
      final weather = await _weatherService.fetchByCoords(
        position.latitude,
        position.longitude,
      );
      setState(() {
        currentWeather = weather;
        isLoadingCurrent = false;
      });
    } catch (e) {
      setState(() => isLoadingCurrent = false);
      if (mounted) myDialog(context, e.toString());
    }
  }

  Future<void> _searchWeather() async {
    if (locationController.text.trim().isEmpty) {
      myDialog(context, "Write your Country!");
      return;
    }

    setState(() {
      isLoadingSearch = true;
      hasSearchResult = false;
    });

    final city = locationController.text.trim();

    try {
      final weather = await _weatherService.fetchByCity(city);
      setState(() {
        searchedWeather = weather;
        isLoadingSearch = false;
        hasSearchResult = true;
      });
    } catch (e) {
      setState(() => isLoadingSearch = false);
      if (mounted) myDialog(context, e.toString());
    }

    locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bgColors = currentWeather != null
        ? WeatherHelper.getWeatherColors(currentWeather!.condition)
        : [const Color(0xFF1E90FF), const Color(0xFF87CEEB)];

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
            onRefresh: _loadCurrentWeather,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  const Center(
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
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      "Pull down to refresh current location",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Current Location Card ──
                  _sectionLabel("Your Current Location"),
                  const SizedBox(height: 8),
                  isLoadingCurrent
                      ? const LoadingCard()
                      : currentWeather == null
                          ? const ErrorCard(message: "Location not found")
                          : WeatherCard(weather: currentWeather!),

                  const SizedBox(height: 28),

                  // ── Search Section ──
                  _sectionLabel("Find City Or Town"),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: TextField(
                      controller: locationController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter City Or Town",
                        hintStyle: const TextStyle(color: Colors.white60),
                        prefixIcon:
                            const Icon(Icons.location_city, color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (_) => _searchWeather(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: isLoadingSearch ? null : _searchWeather,
                      icon: isLoadingSearch
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search),
                      label: Text(
                        isLoadingSearch ? "Finding..." : "See weather",
                        style: const TextStyle(fontSize: 16),
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

                  const SizedBox(height: 20),

                  // ── Search Result ──
                  if (hasSearchResult && searchedWeather != null) ...[
                    _sectionLabel("The Result"),
                    const SizedBox(height: 8),
                    WeatherCard(weather: searchedWeather!),
                  ] else if (!isLoadingSearch) ...[
                    const Center(
                      child: Text(
                        "Upore sohorer nam likhe search koro",
                        style: TextStyle(
                            color: Colors.white60, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
