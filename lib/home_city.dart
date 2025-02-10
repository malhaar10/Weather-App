import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:air_quality_waqi/air_quality_waqi.dart';

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

  String get_aqi_cond() {
    var aqi = _aqi?.airQualityIndex;
    var now_aqi;
    if (aqi == null) {
      now_aqi = 'Unknown';
    } else if (aqi >= 0 && aqi <= 50) {
      now_aqi = 'Good';
    } else if (aqi >= 51 && aqi <= 100) {
      now_aqi = 'Moderate';
    } else if (aqi >= 101 && aqi <= 150) {
      now_aqi = 'Unhealthy for sensitive groups';
    } else if (aqi >= 151 && aqi <= 200) {
      now_aqi = 'Unhealthy';
    } else if (aqi >= 201 && aqi <= 300) {
      now_aqi = 'Very Unhealthy';
    } else {
      now_aqi = 'Hazardous';
    }
    return now_aqi;
  }

  Widget app_ui() {
    var get_aqi = get_aqi_cond();
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    if (_weather == null) {
      return Container(
        width: screenwidth * 0.8,
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
          Container(
            height: screenheight * 0.30,
            width: screenwidth * 0.35,
            margin: EdgeInsets.only(
                top: screenheight * 0.05,
                bottom: screenheight * 0.015,
                left: screenwidth * 0.04,
                right: screenwidth * 0.04),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                borderRadius: BorderRadius.circular(25.0)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _weather?.areaName ?? "",
                          style: TextStyle(
                              fontSize: screenheight * 0.02,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        '${_weather?.temperature?.celsius?.toStringAsFixed(2) ?? ""}°C',
                        style: TextStyle(
                            fontSize: screenheight * 0.04, color: Colors.white),
                      ),
                      Text(_weather?.weatherMain ?? "",
                          style: TextStyle(
                              fontSize: screenheight * 0.03,
                              color: Colors.white)),
                      Text(
                          'Feels Like: ${_weather?.tempFeelsLike?.celsius?.toStringAsFixed(1)}°C',
                          style: TextStyle(
                              fontSize: screenheight * 0.02,
                              color: Colors.white)),
                      Text(
                        '${_weather?.tempMax?.celsius?.toStringAsFixed(1) ?? ""}°C / ${_weather?.tempMin?.celsius?.toStringAsFixed(1) ?? ""}°C',
                        style: TextStyle(
                            fontSize: screenheight * 0.02, color: Colors.white),
                      ),
                    ],
                  ),
                  Align(
                    child: Container(
                      height: screenheight * 0.20,
                      width: screenwidth * 0.30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png"),
                      )),
                    ),
                  )
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: screenheight * 0.1,
                  width: screenwidth * 0.4,
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.only(
                      top: screenheight * 0.01,
                      bottom: screenheight * 0.01,
                      left: screenwidth * 0.04,
                      right: screenwidth * 0.04),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Humidity',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenheight * 0.015),
                      ),
                      Text('${_weather?.humidity?.toStringAsFixed(1)}%',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenheight * 0.027))
                    ],
                  )),
              Container(
                  height: screenheight * 0.1,
                  width: screenwidth * 0.4,
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.only(
                      top: screenheight * 0.01,
                      bottom: screenheight * 0.01,
                      left: screenwidth * 0.04,
                      right: screenwidth * 0.04),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Pressure (mmHg)',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenheight * 0.015),
                      ),
                      Text(
                          '${(_weather?.pressure != null) ? (_weather!.pressure! * 0.75) : null}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenheight * 0.027))
                    ],
                  )),
            ],
          ),
          Container(
              height: screenheight * 0.1,
              width: screenwidth * 0.8,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.only(
                  top: screenheight * 0.01,
                  bottom: screenheight * 0.01,
                  left: screenwidth * 0.04,
                  right: screenwidth * 0.04),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  borderRadius: BorderRadius.circular(25.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Air Quality Index (AQI)',
                    style: TextStyle(
                        color: Colors.white, fontSize: screenheight * 0.015),
                  ),
                  Text('${_aqi?.airQualityIndex}, ${get_aqi}',
                      style: TextStyle(
                          color: Colors.white, fontSize: screenheight * 0.027))
                ],
              )),
          Container(
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
            margin: EdgeInsets.all(10.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                    margin: EdgeInsets.all(10.0),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(52, 47, 47, 0.7),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text('Cloud cover: ${_weather?.cloudiness}%',
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                    margin: EdgeInsets.all(10.0),
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
