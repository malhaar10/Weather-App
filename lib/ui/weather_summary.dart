import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class WeatherSummary extends StatelessWidget {
  const WeatherSummary({
    super.key,
    required this.screenheight,
    required this.screenwidth,
    required this.weather,
  });

  final double screenheight;
  final double screenwidth;
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              weather.areaName ?? "",
              style:
                  TextStyle(fontSize: screenheight * 0.02, color: Colors.white),
            ),
          ),
          Text(
            '${weather.temperature?.celsius?.toStringAsFixed(2) ?? ""}°C',
            style:
                TextStyle(fontSize: screenheight * 0.04, color: Colors.white),
          ),
          Text(weather.weatherMain ?? "",
              style: TextStyle(
                  fontSize: screenheight * 0.03, color: Colors.white)),
          Text(
              'Feels Like: ${weather.tempFeelsLike?.celsius?.toStringAsFixed(1)}°C',
              style: TextStyle(
                  fontSize: screenheight * 0.02, color: Colors.white)),
          Text(
              '${weather.tempMax?.celsius?.toStringAsFixed(1) ?? ""}°C , ${weather.tempMin?.celsius?.toStringAsFixed(1) ?? ""}°C',
              style: TextStyle(
                  fontSize: screenheight * 0.02, color: Colors.white)),
          Text(
              '${weather.date != null ? DateFormat('HH:mm').format(weather.date!) : ""}',
              style: TextStyle(
                  fontSize: screenheight * 0.03, color: Colors.white)),
        ],
      ),
      Align(
        child: Container(
          height: screenheight * 0.20,
          width: screenwidth * 0.30,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(
                "https://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png"),
          )),
        ),
      )
    ]);
  }
}
