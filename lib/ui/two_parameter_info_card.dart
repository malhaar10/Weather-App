import 'package:flutter/material.dart';

class TwoParameterInfoCard extends StatelessWidget {
  const TwoParameterInfoCard(
      {super.key,
      required this.screenheight,
      required this.screenwidth,
      required this.title1,
      required this.body1,
      required this.title2,
      required this.body2});

  final double screenheight;
  final double screenwidth;
  final String title1;
  final String body1;
  final String title2;
  final String body2;

  Widget build(BuildContext context) {
    final double containerwidthfactor = 0.8;
    final double bodyfontsizefactor = 0.021;
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  title1,
                  style: TextStyle(
                      color: Colors.white, fontSize: screenheight * 0.015),
                ),
                Text(body1,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenheight * bodyfontsizefactor))
              ],
            ),
            Column(
              children: [
                Text(
                  title2,
                  style: TextStyle(
                      color: Colors.white, fontSize: screenheight * 0.015),
                ),
                Text(body2,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenheight * bodyfontsizefactor)),
              ],
            )
          ],
        ));
  }
}
