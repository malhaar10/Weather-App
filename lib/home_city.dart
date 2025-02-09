import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:air_quality_waqi/air_quality_waqi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Weather? _weather;
List<Weather>? _forecast;
AirQualityWaqiData? _aqi;

class HomeCity extends StatefulWidget {
  const HomeCity({super.key});

  @override
  State<HomeCity> createState() => HomeCityState();
}

class HomeCityState extends State<HomeCity> {
  late final WeatherFactory wf;
  late final AirQualityWaqi airquality;

  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  Future<Map<String, double>> getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.low);
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }

  void _initializeWeather() async {
    Map<String, double> location = await getLocation();
    double latitude = location['latitude']!;
    double longitude = location['longitude']!;

    wf = WeatherFactory(dotenv.env['WEATHER_APPLCATION_API_KEY']!);
    wf.currentWeatherByLocation(latitude, longitude).then((weather) {
      setState(() {
        _weather = weather;
      });
    });
    List<Weather> forecast =
        await wf.fiveDayForecastByLocation(latitude, longitude);
    setState(() {
      _forecast = forecast;
    });

    airquality = AirQualityWaqi(dotenv.env['AQI_SERVICE_API_KEY']!);
    airquality.feedFromGeoLocation(latitude, longitude).then((aqi) {
      _aqi = aqi;
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
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
                height: screenheight * 0.20,
                width: screenwidth * 0.35,
                margin: EdgeInsets.only(top: 40.0),
                padding: EdgeInsets.all(11.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _weather?.areaName ?? "",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Text(
                      '${_weather?.temperature?.celsius?.toStringAsFixed(1) ?? ""}°C',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    Text(_weather?.weatherMain ?? "",
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                  ],
                )),
            Column(
              children: [
                Container(
                  height: screenheight * 0.20,
                  width: screenwidth * 0.35,
                  margin: EdgeInsets.only(top: 40.0),
                  padding: EdgeInsets.all(11.0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(226, 223, 223, 1),
                      borderRadius: BorderRadius.circular(25.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png"),
                        //fit: BoxFit.contain,
                      )),
                ),
              ],
            )
          ]),
          Container(
              padding: EdgeInsets.symmetric(vertical: screenheight * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${_weather?.tempMax?.celsius?.toStringAsFixed(1) ?? ""}°C / ${_weather?.tempMin?.celsius?.toStringAsFixed(1) ?? ""}°C',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                      'Feels Like: ${_weather?.tempFeelsLike?.celsius?.toStringAsFixed(1)}°C',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              )),
          Container(
            // width: screenwidth * 0.95,
            // height: screenheight * 0.2,
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 9),
            decoration: BoxDecoration(
              color: Color.fromRGBO(52, 47, 47, 0.7),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Text(
              '${_forecast?.length}',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Container(
            width: screenwidth * 0.95,
            height: screenheight * 0.19,
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
            margin: EdgeInsets.symmetric(vertical: 0.2, horizontal: 9),
            decoration: BoxDecoration(
              color: Color.fromRGBO(52, 47, 47, 0.7),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sunrise: ${_weather?.sunrise}',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                Text(
                  'Sunset: ${_weather?.sunset}',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 9),
            decoration: BoxDecoration(
              color: Color.fromRGBO(52, 47, 47, 0.7),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Text(
              'Moon phases',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: screenwidth * 0.42,
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(52, 47, 47, 0.7),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      'Humidity: ${_weather?.humidity?.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: screenwidth * 0.42,
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(52, 47, 47, 0.7),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      'AQI: ${_aqi?.airQualityIndex}',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: screenwidth * 0.42,
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(52, 47, 47, 0.7),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      'Dew Point',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: screenwidth * 0.42,
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(52, 47, 47, 0.7),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text('Cloud cover: ${_weather?.cloudiness}%',
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                  Container(
                    width: screenwidth * 0.42,
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(52, 47, 47, 0.7),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      'Pressure: ${_weather?.pressure?.toStringAsFixed(2)} mmHg',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: screenwidth * 0.42,
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(52, 47, 47, 0.7),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      'Wind: ${_weather?.windSpeed?.toStringAsFixed(2).toString()} km/h',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
