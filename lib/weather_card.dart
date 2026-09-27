import 'package:flutter/material.dart';
import 'package:wather_app/weather_helper.dart';
import 'package:wather_app/weather_model.dart';
import 'info_tile.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final emoji = WeatherHelper.getWeatherEmoji(weather.condition);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
                      weather.city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.condition,
                      style: const TextStyle(
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
                  Text(emoji, style: const TextStyle(fontSize: 42)),
                  Text(
                    "${weather.temperature.toStringAsFixed(1)}°C",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white30),
          const SizedBox(height: 12),

          // Humidity + Wind + Feels Like
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoTile(
                emoji: "💧",
                label: "Humidity",
                value: "${weather.humidity}%",
              ),
              InfoTile(
                emoji: "💨",
                label: "Wind",
                value: "${weather.windSpeed.toStringAsFixed(1)} m/s",
              ),
              InfoTile(
                emoji: "🌡️",
                label: "Feels Like",
                value: "${weather.feelsLike.toStringAsFixed(1)}°C",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Sunrise + Sunset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoTile(emoji: "🌅", label: "Sunrise", value: weather.sunrise),
              InfoTile(emoji: "🌇", label: "Sunset", value: weather.sunset),
            ],
          ),
        ],
      ),
    );
  }
}
