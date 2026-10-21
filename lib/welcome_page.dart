import 'package:flutter/material.dart';
import 'package:wather_app/weather_page.dart';

class WelcomePage extends StatelessWidget {
  final Widget nextPage;

  const WelcomePage({
    super.key,
    required this.nextPage,
  });

  static const Color navy = Color(0xFF102B54);
  static const Color blue = Color(0xFF3478F6);
  static const Color sky = Color(0xFF8DD8FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF153E78),
              Color(0xFF398DE0),
              Color(0xFFB8E8FF),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top label
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wb_cloudy_rounded,
                              color: Colors.white,
                              size: 27,
                            ),
                            const SizedBox(width: 9),
                            Text(
                              'SkyCast',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Weather illustration
                        SizedBox(
                          height: 280,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Soft background circles
                              Container(
                                width: 245,
                                height: 245,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(
                                    alpha: 0.10,
                                  ),
                                ),
                              ),
                              Container(
                                width: 195,
                                height: 195,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: 0.22,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                              ),

                              // Sun
                              const Positioned(
                                top: 25,
                                right: 42,
                                child: Icon(
                                  Icons.wb_sunny_rounded,
                                  size: 94,
                                  color: Color(0xFFFFD76B),
                                ),
                              ),

                              // Main cloud
                              Positioned(
                                left: 15,
                                bottom: 24,
                                child: Container(
                                  width: 245,
                                  height: 125,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                      alpha: 0.17,
                                    ),
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                ),
                              ),

                              const Positioned(
                                left: 8,
                                bottom: 35,
                                child: Icon(
                                  Icons.cloud_rounded,
                                  size: 205,
                                  color: Color(0xFFF7FCFF),
                                ),
                              ),

                              // Small floating cloud
                              Positioned(
                                top: 42,
                                left: 12,
                                child: Icon(
                                  Icons.cloud_rounded,
                                  size: 58,
                                  color: Colors.white.withValues(
                                    alpha: 0.65,
                                  ),
                                ),
                              ),

                              // Small stars
                              const Positioned(
                                top: 28,
                                left: 88,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const Positioned(
                                right: 13,
                                bottom: 48,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 20,
                                  color: Color(0xFFFFE6A3),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Welcome title
                        const Text(
                          'Weather, Made Beautiful.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            height: 1.2,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.8,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Discover the weather around you.\n'
                          'Stay ready for every kind of day.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 16,
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Feature chips
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: const [
                            _FeatureChip(
                              icon: Icons.thermostat_rounded,
                              label: 'Live Weather',
                            ),
                            _FeatureChip(
                              icon: Icons.calendar_month_rounded,
                              label: 'Daily Forecast',
                            ),
                            _FeatureChip(
                              icon: Icons.location_on_rounded,
                              label: 'Your Location',
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Let's Start button
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>MyWeatherPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: navy,
                              elevation: 5,
                              shadowColor: navy.withValues(alpha: 0.25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Let's Start",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 23,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          'YOUR DAY. YOUR WEATHER.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}