import 'package:flutter/material.dart';

class WeatherInfoCard extends StatelessWidget {
  const WeatherInfoCard(
      {super.key,
      required this.screenheight,
      required this.screenwidth,
      required this.title,
      required this.body,
      this.isThin = false});

  final double screenheight;
  final double screenwidth;
  final String title;
  final String body;
  final bool isThin;
  @override
  Widget build(BuildContext context) {
    final double containerwidthfactor = isThin ? 0.4 : 0.8;
    final double bodyfontsizefactor = isThin ? 0.027 : 0.023;
    return Container(
        height: screenheight * 0.1,
        width: screenwidth * containerwidthfactor,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(
            top: screenheight * 0.01,
            bottom: screenheight * 0.01,
            left: screenwidth * 0.04,
            right: screenwidth * 0.04),
        decoration: BoxDecoration(
            color: Color.fromRGBO(43, 40, 40, 0.247),
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
                    color: Colors.white,
                    fontSize: screenheight * bodyfontsizefactor))
          ],
        ));
  }
}
