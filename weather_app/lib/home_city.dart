import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:geolocator/geolocator.dart';

void main() => runApp(const HomeCity());

class HomeCity extends StatelessWidget {
  const HomeCity({super.key});

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bp_gradient.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              children: [
                Text('    ',
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                Container(
                  width: screenwidth * 0.95,
                  height: screenheight * 0.3,
                  padding:
                      EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(52, 47, 47, 0.7),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    'Current Weather',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Container(
                  width: screenwidth * 0.95,
                  height: screenheight * 0.2,
                  padding:
                      EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
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
          ],
        ),
      ),
    );
  }
}
