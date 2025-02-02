// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

Weather? _weather;

class HomeCity extends StatefulWidget {
  const HomeCity({super.key});

  @override
  State<HomeCity> createState() => HomeCityState();
}

class HomeCityState extends State<HomeCity> {
  late final WeatherFactory wf;

  // Weather? _weather;

  @override
  void initState() {
    //pull and store weather information here
    super.initState();
    wf = WeatherFactory(dotenv.env['WEATHER_APPLCATION_API_KEY']!);
    wf.currentWeatherByCityName("Mumbai").then((weather) {
      setState(() {
        _weather = weather;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: app_ui(),
      ),
    );
  }

  Widget app_ui() {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    if (_weather == null) {
      return Container(
        width: screenwidth,
        height: screenheight,
        color: Colors.black, // Set the background color to black
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Weather data not available at the moment!',
            style: TextStyle(fontSize: 30, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bp_gradient.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        children: [
          Text('    ', style: TextStyle(fontSize: 30, color: Colors.white)),
          locationHeader(),
          datetime(),
          Container(
            width: screenwidth * 0.95,
            height: screenheight * 0.3,
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(52, 47, 47, 0.7),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              _weather?.weatherDescription ?? "",
            ),
          ),
          Container(
            width: screenwidth * 0.95,
            height: screenheight * 0.2,
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(52, 47, 47, 0.7),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              'Hourly weather',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenwidth * 0.42,
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(52, 47, 47, 0.7),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'AQI',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Container(
                width: screenwidth * 0.42,
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(52, 47, 47, 0.7),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'Visibility',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenwidth * 0.42,
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(52, 47, 47, 0.7),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'UV index',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Container(
                width: screenwidth * 0.42,
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(52, 47, 47, 0.7),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'Pressure',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenwidth * 0.42,
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(52, 47, 47, 0.7),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'Dew Point',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Container(
                width: screenwidth * 0.42,
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(52, 47, 47, 0.7),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  'Wind',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          Container(
            width: screenwidth * 0.95,
            height: screenheight * 0.19,
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(52, 47, 47, 0.7),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              'Sunrise & Sunset',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Container(
            width: screenwidth * 0.95,
            height: screenheight * 0.19,
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(52, 47, 47, 0.7),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              'Moon phases',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

Widget locationHeader() {
  return Text(_weather?.areaName ?? "",
      style: TextStyle(fontSize: 20, color: Colors.white));
}

Widget datetime() {
  DateTime now = _weather!.date!;
  return Text(DateFormat("h:mm a").format(now),
      style: TextStyle(fontSize: 20, color: Colors.white));
  // ignore: dead_code
  Row(
    children: [
      Text(DateFormat("EEEE").format(now),
          style: TextStyle(fontSize: 30, color: Colors.white)),
      Text(DateFormat("d.m.y").format(now),
          style: TextStyle(fontSize: 30, color: Colors.white))
    ],
  );
}
