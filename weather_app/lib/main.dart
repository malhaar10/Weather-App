import 'package:flutter/material.dart';
import 'home_city.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeCity(),
    );
  }
}

//AQI, UV index, Pressure, Visibility, Sunrise & sunset, Moon, Dew point, hourly weather, precipitation, wind
