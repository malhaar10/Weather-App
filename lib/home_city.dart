import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:air_quality_waqi/air_quality_waqi.dart';
import 'package:intl/intl.dart';
import 'package:weather_animation/weather_animation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/searchpage.dart';
import 'package:weather_app/ui/two_parameter_info_card.dart';
import 'package:weather_app/ui/weather_info_card.dart';
import 'package:weather_app/ui/weather_summary.dart';
import 'aqi_cond.dart';
import 'get_direction.dart';
import 'wrapper_scene.dart';
import 'searchpage.dart';

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
  String _lastText = "";
  String? iconString;
  String ow_link = 'https://openweathermap.org/';

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

        await _fetchWeatherData(latitude, longitude);
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
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
                    hintText: 'Search city',
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city_sharp),
            label: 'Locations',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
          } else if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage()));
          }
        },
      ),
    );
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: screenwidth * 0.1,
                    child: Text(
                      DateFormat('dd').format(forecast.date!),
                      style: TextStyle(
                          color: Colors.white, fontSize: screenheight * 0.023),
                    )),
                SizedBox(
                    width: screenwidth * 0.15,
                    child: Text(
                      '${forecast.temperature?.celsius?.toStringAsFixed(1)}°C',
                      style: TextStyle(
                          color: Colors.white, fontSize: screenheight * 0.023),
                    )),
                Align(
                  child: Container(
                    height: screenheight * 0.05,
                    width: screenwidth * 0.1,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(
                          "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png"),
                    )),
                  ),
                ),
                SizedBox(width: screenwidth * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: screenwidth * 0.4,
                    child: Text(
                      '${forecast.weatherDescription}',
                      style: TextStyle(
                          color: Colors.white, fontSize: screenheight * 0.023),
                    ),
                  ),
                )
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget app_ui() {
    var wdes = _weather?.weatherConditionCode;
    var aqi = _aqi?.airQualityIndex;
    var angle = _weather?.windDegree;

    String? iconString = _weather?.weatherIcon;
    WrapperScene? sCene = getScene(iconString, wdes);
    var get_aqi = get_aqi_cond(aqi);
    var direc = getDirection(angle);

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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Color.fromRGBO(43, 40, 40, 0.5)),
              child: WeatherSummary(
                screenheight: screenheight,
                screenwidth: screenwidth,
                weather: _weather!,
              ),
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
                    color: Color.fromRGBO(43, 40, 40, 0.5),
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
                WeatherInfoCard(
                    isThin: true,
                    screenheight: screenheight,
                    screenwidth: screenwidth,
                    title: 'Humidity',
                    body: '${_weather?.humidity?.toStringAsFixed(1)}%'),
                WeatherInfoCard(
                    isThin: true,
                    screenheight: screenheight,
                    screenwidth: screenwidth,
                    title: "Pressure (mmHg)",
                    body:
                        '${(_weather?.pressure != null) ? (_weather!.pressure! * 0.75) : null}')
              ],
            ),
            WeatherInfoCard(
                screenheight: screenheight,
                screenwidth: screenwidth,
                title: "Air Quality Index (AQI)",
                body: "${_aqi?.airQualityIndex}, ${get_aqi}"),
            WeatherInfoCard(
                screenheight: screenheight,
                screenwidth: screenwidth,
                title: "Wind",
                body:
                    '${_weather?.windSpeed} kmph, ${_weather?.windDegree}°, ${direc}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WeatherInfoCard(
                    isThin: true,
                    screenheight: screenheight,
                    screenwidth: screenwidth,
                    title: "Clouds",
                    body: '${_weather?.cloudiness}%'),
                WeatherInfoCard(
                    screenheight: screenheight,
                    screenwidth: screenwidth,
                    title: 'Area',
                    body: '${_weather?.areaName}',
                    isThin: true)
              ],
            ),
            TwoParameterInfoCard(
                screenheight: screenheight,
                screenwidth: screenwidth,
                title1: 'Sunrise',
                body1:
                    '${_weather?.sunrise != null ? DateFormat('HH:mm').format(_weather!.sunrise!) : ""}',
                title2: 'Sunset',
                body2:
                    '${_weather?.sunset != null ? DateFormat('HH:mm').format(_weather!.sunset!) : ""}'),
            SizedBox(height: screenheight * 0.02),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Weather data provided by OpenWeather and World Air Quality Index (WAQI)',
                style: TextStyle(fontSize: screenheight * 0.013),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
