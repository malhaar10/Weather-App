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
            Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('    ',
                    style: TextStyle(fontSize: 40, color: Colors.white)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(52, 47, 47, 0.7),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        'Text 1 in first row',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Future<Position> _determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return Future.error('Location services are disabled.');
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return Future.error('Location permissions are denied');
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }

//   return await Geolocator.getCurrentPosition();
// }
