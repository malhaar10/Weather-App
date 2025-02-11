import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:air_quality_waqi/air_quality_waqi.dart';
import 'package:intl/intl.dart';
import 'package:weather_animation/weather_animation.dart';

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

  String getDirection() {
    var angle = _weather?.windDegree;
    var direc;
    if (angle == null) {
      direc = 'Unknown';
    } else if (angle >= 337.5 && angle <= 22.5) {
      direc = 'N';
    } else if (angle >= 22.5 && angle <= 67.5) {
      direc = 'NE';
    } else if (angle >= 67.5 && angle <= 112.5) {
      direc = 'E';
    } else if (angle >= 112.5 && angle <= 157.5) {
      direc = 'SE';
    } else if (angle >= 157.5 && angle <= 202.5) {
      direc = 'S';
    } else if (angle >= 202.5 && angle <= 247.5) {
      direc = 'SW';
    } else if (angle >= 247.5 && angle <= 292.5) {
      direc = 'W';
    } else if (angle >= 292.5 && angle <= 337.5) {
      direc = 'NW';
    }
    return direc;
  }

  Widget forecastList() {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    List<Weather> dailyForecasts = [];
    Set<String> seenDates = {};

    _forecast?.forEach((forecast) {
      String date = DateFormat('yyyy-MM-dd').format(forecast.date!);
      if (!seenDates.contains(date)) {
        seenDates.add(date);
        dailyForecasts.add(forecast);
      }
    });

    return Container(
      width: screenwidth * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...dailyForecasts.map((forecast) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  DateFormat('dd').format(forecast.date!),
                  style: TextStyle(
                      color: Colors.white, fontSize: screenheight * 0.025),
                ),
                Text(
                  '${forecast.temperature?.celsius?.toStringAsFixed(1)}°C',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenheight * 0.025),
                ),
                Text(
                  '${forecast.weatherDescription}',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenheight * 0.025),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  WeatherScene? getScene() {
    var wdes = _weather?.weatherConditionCode;
    var scene;
    if (wdes != null) {
      if (wdes >= 200 && wdes <= 232) {
        scene = WeatherScene.stormy;
      } else if (wdes >= 300 && wdes <= 321) {
        scene = WeatherScene.rainyOvercast;
      } else if (wdes >= 500 && wdes <= 531) {
        scene = WeatherScene.showerSleet;
      } else if (wdes >= 600 && wdes <= 622) {
        scene = WeatherScene.snowfall;
      } else if (wdes >= 701 && wdes <= 781) {
        scene = WeatherScene.sunset;
      } else if (wdes == 800) {
        scene = WeatherScene.scorchingSun;
      } else if (wdes >= 801 && wdes <= 804) {
        scene = WeatherScene.sunset;
      }
    }
    return scene;
  }

  Widget app_ui() {
    var sCene = getScene();
    var get_aqi = get_aqi_cond();
    var direc = getDirection();
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    if (_weather == null) {
      return Container(
        width: screenwidth * 0.8,
        height: screenheight * 0.7,
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
    return Stack(
      children: [
        Container(
          width: screenwidth,
          height: screenheight,
          child: WrapperScene.weather(scene: sCene ?? WeatherScene.frosty),
        ),
        ListView(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
          children: [
            Container(
              height: screenheight * 0.30,
              width: screenwidth * 0.35,
              margin: EdgeInsets.only(
                  top: screenheight * 0.3,
                  bottom: screenheight * 0.015,
                  left: screenwidth * 0.04,
                  right: screenwidth * 0.04),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  //color: Color.fromRGBO(0, 0, 0, 0.6),
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
                              fontSize: screenheight * 0.04,
                              color: Colors.white),
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
                              fontSize: screenheight * 0.02,
                              color: Colors.white),
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
            Container(
                width: screenwidth * 0.8,
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.only(
                    top: screenheight * 0.01,
                    bottom: screenheight * 0.01,
                    left: screenwidth * 0.04,
                    right: screenwidth * 0.04),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.25),
                    borderRadius: BorderRadius.circular(25.0)),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Forecast',
                      style: TextStyle(
                          color: Colors.white, fontSize: screenheight * 0.015),
                    ),
                    SizedBox(height: 10.0),
                    forecastList()
                  ],
                )),
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
                        color: Color.fromRGBO(255, 255, 255, 0.25),
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
                        color: Color.fromRGBO(255, 255, 255, 0.25),
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
                    color: Color.fromRGBO(255, 255, 255, 0.25),
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
                            color: Colors.white,
                            fontSize: screenheight * 0.023))
                  ],
                )),
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
                  color: Color.fromRGBO(255, 255, 255, 0.25),
                  borderRadius: BorderRadius.circular(25.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Wind',
                    style: TextStyle(
                        color: Colors.white, fontSize: screenheight * 0.015),
                  ),
                  Text(
                      '${_weather?.windSpeed} kmph, ${_weather?.windDegree}°, ${direc}',
                      style: TextStyle(
                          color: Colors.white, fontSize: screenheight * 0.023))
                ],
              ),
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
                        color: Color.fromRGBO(255, 255, 255, 0.25),
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Clouds',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenheight * 0.015),
                        ),
                        Text('${_weather?.cloudiness}%',
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
                        color: Color.fromRGBO(255, 255, 255, 0.25),
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Condition',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenheight * 0.015),
                        ),
                        Text('${_weather?.weatherMain}',
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
                    color: Color.fromRGBO(255, 255, 255, 0.25),
                    borderRadius: BorderRadius.circular(25.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Sunrise',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenheight * 0.015),
                        ),
                        Text(
                            '${_weather?.sunrise != null ? DateFormat('HH:mm').format(_weather!.sunrise!) : ""}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenheight * 0.023))
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Sunset',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenheight * 0.015),
                        ),
                        Text(
                            '${_weather?.sunset != null ? DateFormat('HH:mm').format(_weather!.sunset!) : ""}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenheight * 0.023))
                      ],
                    )
                  ],
                )),
          ],
        ),
      ],
    );
  }
}
