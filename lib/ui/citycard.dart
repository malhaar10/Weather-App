import 'package:flutter/material.dart';

class CityCard extends StatelessWidget {
  const CityCard(
      {super.key,
      required this.screenheight,
      required this.screenwidth,
      required this.location});

  final double screenheight;
  final double screenwidth;
  final String location;

  Widget build(BuildContext context) {
    final double containerwidthfactor = 0.8;
    final double bodyfontsizefactor = 0.023;
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
            color: Color.fromRGBO(43, 40, 40, 0.5),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          children: [Text(location)],
        ));
  }
}
