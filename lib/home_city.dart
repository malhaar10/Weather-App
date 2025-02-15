import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:air_quality_waqi/air_quality_waqi.dart';
import 'package:intl/intl.dart';
import 'package:weather_animation/weather_animation.dart';
import 'package:http/http.dart' as http; // Import http

Weather? _weather;
List<Weather>? _forecast;
AirQualityWaqiData? _aqi;

class HomeCity extends StatefulWidget {
  const HomeCity({Key? key}) : super(key: key);

  @override
  State<HomeCity> createState() => HomeCityState();
}

class HomeCityState extends State<HomeCity> {
  WeatherFactory? wf;
  AirQualityWaqi? airquality;
  Key _key = UniqueKey();
  TextEditingController _cityController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  var time = _weather?.date?.hour;

  @override
  void initState() {
    super.initState();
    _initializeWeather();
    // Listen for changes in the TextField
    _cityController.addListener(_onCityTextChanged);
  }

  @override
  void dispose() {
    _cityController.removeListener(_onCityTextChanged);
    _cityController.dispose();
    super.dispose();
  }

  void _onCityTextChanged() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (_cityController.text.isNotEmpty &&
          mounted &&
          _cityController.text == _lastText) {
        _searchCities(_cityController.text);
      }
    });

    _lastText = _cityController.text;
  }

  String _lastText = "";

  Future<void> _searchCities(String cityName) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String apiKey = dotenv.env['WEATHER_APPLCATION_API_KEY']!;
    final String url =
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=5&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _searchResults = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error: ${response.statusCode} - ${response.body}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Future<Map<String, double>> getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
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

    _fetchWeatherData(latitude, longitude);
  }

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    wf = WeatherFactory(dotenv.env['WEATHER_APPLCATION_API_KEY']!);
    try {
      Weather weather = await wf!.currentWeatherByLocation(latitude, longitude);
      setState(() {
        _weather = weather;
      });

      List<Weather> forecast =
          await wf!.fiveDayForecastByLocation(latitude, longitude);
      setState(() {
        _forecast = forecast;
      });

      airquality = AirQualityWaqi(dotenv.env['AQI_SERVICE_API_KEY']!);
      AirQualityWaqiData aqi =
          await airquality!.feedFromGeoLocation(latitude, longitude);
      setState(() {
        _aqi = aqi;
      });
    } catch (e) {
      print("Error initializing weather data: $e");
    }
  }

  Future<void> _fetchWeatherDataByCity(String cityName) async {
    try {
      Map<String, double>? coordinates =
          await _getCoordinatesFromCityName(cityName);

      if (coordinates != null) {
        double latitude = coordinates['latitude']!;
        double longitude = coordinates['longitude']!;

        _fetchWeatherData(latitude, longitude);
      } else {
        setState(() {
          _errorMessage = 'City not found.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching weather data: $e';
      });
    }
  }

  Future<Map<String, double>?> _getCoordinatesFromCityName(
      String cityName) async {
    final String apiKey = dotenv.env['WEATHER_APPLCATION_API_KEY']!;
    final String geocodingUrl =
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(geocodingUrl));

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        if (results.isNotEmpty) {
          return {
            'latitude': results[0]['lat'],
            'longitude': results[0]['lon'],
          };
        } else {
          return null; // City not found
        }
      } else {
        print('Geocoding API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
      return null;
    }
  }

  void refreshPage() {
    setState(() {
      _weather = null;
      _forecast = null;
      _aqi = null;
      wf = null;
      airquality = null;
      _key = UniqueKey();
      _initializeWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          app_ui(),
          Positioned(
            width: MediaQuery.of(context).size.width * 0.35,
            top: MediaQuery.of(context).size.height * 0.05,
            right: MediaQuery.of(context).size.width * 0.23,
            child: Column(
              children: [
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(255, 255, 255, 0.5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide.none),
                    hintText: 'Search city..',
                    // suffixIcon: IconButton(  // Removed suffixIcon IconButton
                    //   icon: Icon(Icons.search),
                    //   onPressed: () {
                    //     _fetchWeatherDataByCity(_cityController.text);
                    //   },
                    // ),
                  ),
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else if (_errorMessage.isNotEmpty)
                  Text(_errorMessage, style: TextStyle(color: Colors.red))
                else if (_searchResults.isNotEmpty)
                  Container(
                    height: 200, // Adjust height as needed
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final city = _searchResults[index];
                        return ListTile(
                          title: Text(city['name']),
                          subtitle: Text(
                              '${city['state'] ?? ''}, ${city['country']}'),
                          onTap: () {
                            // Fetch weather data for the selected city
                            _fetchWeatherDataByCity(city['name']);
                            // Clear search results and close dropdown
                            setState(() {
                              _searchResults = [];
                              _cityController.text = city['name'];
                            });
                            FocusScope.of(context)
                                .unfocus(); // Remove focus from TextField
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            right: MediaQuery.of(context).size.width * 0.04,
            child: FloatingActionButton(
              onPressed: refreshPage,
              child: Icon(
                Icons.refresh,
                color: Colors.black,
              ),
              elevation: 0,
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
            ),
          ),
        ],
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
    } else if (angle != null) {
      if (angle >= 337.5 || angle <= 22.5) {
        direc = 'N';
      } else if (angle > 22.5 && angle <= 67.5) {
        direc = 'NE';
      } else if (angle > 67.5 && angle <= 112.5) {
        direc = 'E';
      } else if (angle > 112.5 && angle <= 157.5) {
        direc = 'SE';
      } else if (angle > 157.5 && angle <= 202.5) {
        direc = 'S';
      } else if (angle > 202.5 && angle <= 247.5) {
        direc = 'SW';
      } else if (angle > 247.5 && angle <= 292.5) {
        direc = 'W';
      } else if (angle > 292.5 && angle < 337.5) {
        direc = 'NW';
      } else {
        direc = 'Unknown';
      }
    } else {
      direc = 'Unknown';
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
                Align(
                  child: Container(
                    height: screenheight * 0.04,
                    width: screenwidth * 0.1,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(
                          "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png"),
                    )),
                  ),
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

  WrapperScene? getScene() {
    var wdes = _weather?.weatherConditionCode;
    WrapperScene? scene;
    if (wdes != null) {
      if (wdes >= 200 && wdes <= 232) {
        scene = WrapperScene.weather(scene: WeatherScene.stormy);
      } else if (wdes >= 300 && wdes <= 311) {
        //rain
        scene = WrapperScene(
          sizeCanvas: Size(350, 540),
          isLeftCornerGradient: false,
          colors: [
            Color.fromARGB(0xb6, 0x45, 0x5a, 0x64),
          ],
          children: [
            RainWidget(
              rainConfig: RainConfig(
                  count: 10,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(0x99, 0x78, 0x90, 0x9c),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 120,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
            CloudWidget(
              cloudConfig: CloudConfig(
                  size: 216,
                  color: Color.fromARGB(0xaa, 0xff, 0xff, 0xff),
                  icon: IconData(63056, fontFamily: 'MaterialIcons'),
                  widgetCloud: null,
                  x: 24,
                  y: 5,
                  scaleBegin: 1,
                  scaleEnd: 1.1,
                  scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  slideX: 3,
                  slideY: 1,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
            ),
            CloudWidget(
              cloudConfig: CloudConfig(
                  size: 250,
                  color: Color.fromARGB(0xe9, 0xff, 0xff, 0xff),
                  icon: IconData(63056, fontFamily: 'MaterialIcons'),
                  widgetCloud: null,
                  x: 70,
                  y: 5,
                  scaleBegin: 1,
                  scaleEnd: 1.1,
                  scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  slideX: 11,
                  slideY: 5,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
            ),
            RainWidget(
              rainConfig: RainConfig(
                  count: 5,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(0x99, 0x78, 0x90, 0x9c),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 63,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
          ],
        );
      } else if (wdes >= 312 && wdes <= 321) {
        scene = WrapperScene(
          sizeCanvas: Size(350, 540),
          isLeftCornerGradient: false,
          colors: [
            Color.fromARGB(0xb6, 0x45, 0x5a, 0x64),
          ],
          children: [
            RainWidget(
              rainConfig: RainConfig(
                  count: 10,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(0x99, 0x78, 0x90, 0x9c),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 120,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
            RainWidget(
              rainConfig: RainConfig(
                  count: 13,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(0x99, 0x78, 0x90, 0x9c),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 85,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
            CloudWidget(
              cloudConfig: CloudConfig(
                  size: 216,
                  color: Color.fromARGB(0xaa, 0xff, 0xff, 0xff),
                  icon: IconData(63056, fontFamily: 'MaterialIcons'),
                  widgetCloud: null,
                  x: 24,
                  y: 5,
                  scaleBegin: 1,
                  scaleEnd: 1.1,
                  scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  slideX: 11,
                  slideY: 5,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
            ),
            CloudWidget(
              cloudConfig: CloudConfig(
                  size: 250,
                  color: Color.fromARGB(0xe9, 0xff, 0xff, 0xff),
                  icon: IconData(63056, fontFamily: 'MaterialIcons'),
                  widgetCloud: null,
                  x: 70,
                  y: 5,
                  scaleBegin: 1,
                  scaleEnd: 1.1,
                  scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  slideX: 11,
                  slideY: 5,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
            ),
            RainWidget(
              rainConfig: RainConfig(
                  count: 10,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(0x99, 0x78, 0x90, 0x9c),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 120,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
          ],
        );
      } else if (wdes >= 500 && wdes <= 501) {
        scene = WrapperScene(
          sizeCanvas: Size(350, 540),
          isLeftCornerGradient: false,
          colors: [
            Color(0xb6455a64),
          ],
          children: [
            RainWidget(
              rainConfig: RainConfig(
                  count: 10,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(153, 120, 144, 156),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 120,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
            CloudWidget(
              cloudConfig: CloudConfig(
                  size: 216,
                  color: Color.fromARGB(170, 255, 255, 255),
                  icon: IconData(63056, fontFamily: 'MaterialIcons'),
                  widgetCloud: null,
                  x: 24,
                  y: 5,
                  scaleBegin: 1,
                  scaleEnd: 1.1,
                  scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  slideX: 3,
                  slideY: 1,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
            ),
            CloudWidget(
              cloudConfig: CloudConfig(
                  size: 250,
                  color: Color.fromARGB(
                    233,
                    255,
                    255,
                    255,
                  ),
                  icon: IconData(63056, fontFamily: 'MaterialIcons'),
                  widgetCloud: null,
                  x: 70,
                  y: 5,
                  scaleBegin: 1,
                  scaleEnd: 1.1,
                  scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  slideX: 11,
                  slideY: 5,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
            ),
            RainWidget(
              rainConfig: RainConfig(
                  count: 5,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(153, 120, 144, 156),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 63,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
          ],
        );
      } else if (wdes >= 502 && wdes <= 531) {
        scene = WrapperScene(
          sizeCanvas: Size(350, 540),
          isLeftCornerGradient: false,
          colors: [
            Color.fromARGB(0xb6, 0x45, 0x5a, 0x64),
          ],
          children: [
            RainWidget(
              rainConfig: RainConfig(
                  count: 10,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(0x99, 0x78, 0x90, 0x9c),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 120,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
            RainWidget(
              rainConfig: RainConfig(
                  count: 13,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(0x99, 0x78, 0x90, 0x9c),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 85,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
            CloudWidget(
              cloudConfig: CloudConfig(
                  size: 216,
                  color: Color.fromARGB(0xaa, 0xff, 0xff, 0xff),
                  icon: IconData(63056, fontFamily: 'MaterialIcons'),
                  widgetCloud: null,
                  x: 24,
                  y: 5,
                  scaleBegin: 1,
                  scaleEnd: 1.1,
                  scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  slideX: 11,
                  slideY: 5,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
            ),
            CloudWidget(
              cloudConfig: CloudConfig(
                  size: 250,
                  color: Color.fromARGB(0xe9, 0xff, 0xff, 0xff),
                  icon: IconData(63056, fontFamily: 'MaterialIcons'),
                  widgetCloud: null,
                  x: 70,
                  y: 5,
                  scaleBegin: 1,
                  scaleEnd: 1.1,
                  scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  slideX: 11,
                  slideY: 5,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
            ),
            RainWidget(
              rainConfig: RainConfig(
                  count: 10,
                  lengthDrop: 12,
                  widthDrop: 4,
                  color: Color.fromARGB(0x99, 0x78, 0x90, 0x9c),
                  isRoundedEndsDrop: true,
                  widgetRainDrop: null,
                  fallRangeMinDurMill: 500,
                  fallRangeMaxDurMill: 1500,
                  areaXStart: 120,
                  areaXEnd: 190,
                  areaYStart: 215,
                  areaYEnd: 540,
                  slideX: 2,
                  slideY: 0,
                  slideDurMill: 2000,
                  slideCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                  fallCurve: Cubic(0.55, 0.09, 0.68, 0.53),
                  fadeCurve: Cubic(0.95, 0.05, 0.80, 0.04)),
            ),
          ],
        );
      } else if (wdes >= 600 && wdes <= 602) {
        scene = WrapperScene.weather(scene: WeatherScene.snowfall);
      } else if (wdes >= 611 && wdes <= 622) {
        scene = WrapperScene.weather(scene: WeatherScene.showerSleet);
      } else if (wdes >= 701 && wdes <= 731) {
        scene = WrapperScene(
          sizeCanvas: Size(350, 540),
          isLeftCornerGradient: false,
          colors: [
            Color(0x8a2196f3),
            Color(0x63263238),
          ],
          children: [],
        );
      } else if (wdes == 741) {
        scene = WrapperScene(
          sizeCanvas: Size(350, 540),
          isLeftCornerGradient: false,
          colors: [
            Color(0x8a2196f3),
            Color(0xcbb0bec5),
          ],
          children: [],
        );
      } else if (wdes >= 751 && wdes <= 781) {
        scene = WrapperScene(
          sizeCanvas: Size(350, 540),
          isLeftCornerGradient: false,
          colors: [
            Color(0x982196f3),
            Color(0xff795548),
          ],
          children: [],
        );
      } else if (wdes == 800) {
        if (_weather!.date!.hour > 18) {
          scene = WrapperScene(
            sizeCanvas: Size(350, 540),
            isLeftCornerGradient: false,
            colors: [
              Color.fromARGB(0xcb, 0x0d, 0x47, 0xa1),
            ],
            children: [
              SunWidget(
                sunConfig: SunConfig(
                    width: 1042,
                    blurSigma: 13,
                    blurStyle: BlurStyle.solid,
                    isLeftLocation: true,
                    coreColor: Color.fromARGB(0xd4, 0xff, 0xf3, 0xe0),
                    midColor: Color.fromARGB(0x00, 0xff, 0xee, 0x58),
                    outColor: Color.fromARGB(0x00, 0xff, 0xa7, 0x26),
                    animMidMill: 1500,
                    animOutMill: 1500),
              ),
            ],
          );
        } else {
          scene = WrapperScene.weather(scene: WeatherScene.scorchingSun);
        }
      } else if (wdes >= 801 && wdes <= 804) {
        if (_weather!.date!.hour > 18) {
          scene = WrapperScene(
            sizeCanvas: Size(350, 540),
            isLeftCornerGradient: false,
            colors: [
              Color.fromARGB(0xff, 0x1a, 0x23, 0x7e),
            ],
            children: [
              CloudWidget(
                cloudConfig: CloudConfig(
                    size: 176,
                    color: Color.fromARGB(0xf8, 0xff, 0xff, 0xff),
                    icon: IconData(63056, fontFamily: 'MaterialIcons'),
                    widgetCloud: null,
                    x: 103,
                    y: 59,
                    scaleBegin: 1,
                    scaleEnd: 1.1,
                    scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                    slideX: 11,
                    slideY: 5,
                    slideDurMill: 2000,
                    slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
              ),
              CloudWidget(
                cloudConfig: CloudConfig(
                    size: 250,
                    color: Color.fromARGB(0xe3, 0xff, 0xff, 0xff),
                    icon: IconData(63056, fontFamily: 'MaterialIcons'),
                    widgetCloud: null,
                    x: 0,
                    y: -31,
                    scaleBegin: 1,
                    scaleEnd: 1.1,
                    scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                    slideX: 11,
                    slideY: 5,
                    slideDurMill: 2000,
                    slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
              ),
              SunWidget(
                sunConfig: SunConfig(
                    width: 588,
                    blurSigma: 6,
                    blurStyle: BlurStyle.solid,
                    isLeftLocation: true,
                    coreColor: Color.fromARGB(0xae, 0xff, 0xf3, 0xe0),
                    midColor: Color.fromARGB(0x00, 0xff, 0xee, 0x58),
                    outColor: Color.fromARGB(0x00, 0xff, 0xa7, 0x26),
                    animMidMill: 462,
                    animOutMill: 1794),
              ),
            ],
          );
        } else {
          scene = WrapperScene(
            sizeCanvas: Size(350, 540),
            isLeftCornerGradient: false,
            colors: [
              Color.fromARGB(0xe1, 0x21, 0x96, 0xf3),
            ],
            children: [
              SunWidget(
                sunConfig: SunConfig(
                    width: -1566,
                    blurSigma: 12,
                    blurStyle: BlurStyle.solid,
                    isLeftLocation: true,
                    coreColor: Color.fromARGB(0xff, 0xff, 0x98, 0x00),
                    midColor: Color.fromARGB(0x35, 0xff, 0xee, 0x58),
                    outColor: Color.fromARGB(0x00, 0xff, 0xa7, 0x26),
                    animMidMill: 202,
                    animOutMill: 901),
              ),
              CloudWidget(
                cloudConfig: CloudConfig(
                    size: 250,
                    color: Color.fromARGB(0xe3, 0xff, 0xff, 0xff),
                    icon: IconData(63056, fontFamily: 'MaterialIcons'),
                    widgetCloud: null,
                    x: 0,
                    y: -31,
                    scaleBegin: 1,
                    scaleEnd: 1.1,
                    scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                    slideX: 11,
                    slideY: 5,
                    slideDurMill: 2000,
                    slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
              ),
              CloudWidget(
                cloudConfig: CloudConfig(
                    size: 176,
                    color: Color.fromARGB(0xf8, 0xff, 0xff, 0xff),
                    icon: IconData(63056, fontFamily: 'MaterialIcons'),
                    widgetCloud: null,
                    x: 103,
                    y: 59,
                    scaleBegin: 1,
                    scaleEnd: 1.1,
                    scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00),
                    slideX: 11,
                    slideY: 5,
                    slideDurMill: 2000,
                    slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),
              ),
            ],
          );
        }
      }
    }
    return scene;
  }

  Widget app_ui() {
    WrapperScene? sCene = getScene();
    var get_aqi = get_aqi_cond();
    var direc = getDirection();
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    if (_weather == null) {
      return Container(
        alignment: Alignment.center,
        width: screenwidth,
        height: screenheight,
        color: Colors.black,
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
        Container(width: screenwidth, height: screenheight, child: sCene),
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
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
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
                            '${_weather?.tempMax?.celsius?.toStringAsFixed(1) ?? ""}°C , ${_weather?.tempMin?.celsius?.toStringAsFixed(1) ?? ""}°C',
                            style: TextStyle(
                                fontSize: screenheight * 0.02,
                                color: Colors.white)),
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
                        Text('${_weather?.date?.hour}',
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
