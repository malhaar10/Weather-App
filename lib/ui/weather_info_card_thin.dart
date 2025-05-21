import 'package:flutter/material.dart';

class WeatherInfoCardThin extends StatelessWidget {
  const WeatherInfoCardThin(
      {super.key,
      required this.screenheight,
      required this.screenwidth,
      required this.title,
      required this.body});

  final double screenheight;
  final double screenwidth;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screenheight * 0.1,
        width: screenwidth * 0.4,
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
              title,
              style: TextStyle(
                  color: Colors.white, fontSize: screenheight * 0.015),
            ),
            Text(body,
                style: TextStyle(
                    color: Colors.white, fontSize: screenheight * 0.025))
          ],
        ));
  }
}
