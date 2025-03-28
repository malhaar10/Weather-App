import 'package:flutter/material.dart';
import 'package:weather_app/ui/citycard.dart';
import 'home_city.dart';

double screenwidth = 500;
double screenheight = 1000;

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CityCard(
            screenheight: screenheight,
            screenwidth: screenwidth,
            location: 'Nagpur'),
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
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => HomeCityState()));
            } else if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            }
          },
        ));
  }
}
