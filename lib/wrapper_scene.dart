import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:weather_animation/weather_animation.dart';

WrapperScene? getScene(String? iconString, var wdes) {
  bool isDay = false;
  if (iconString != null) {
    if (iconString.endsWith('d')) {
      isDay = true;
    }
  }
  WrapperScene? scene;
  if (wdes != null) {
    if (wdes >= 200 && wdes <= 232) {
      //storm
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
      //heavy rain
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
      // rain
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
      //heavy rain
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
      //snowfall
      scene = WrapperScene.weather(scene: WeatherScene.snowfall);
    } else if (wdes >= 611 && wdes <= 622) {
      //sleet
      scene = WrapperScene.weather(scene: WeatherScene.showerSleet);
    } else if (wdes >= 701 && wdes <= 731) {
      //fog
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
      //fog
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
      //smoke, dust
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
      if (isDay == false) {
        //clear night
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
        //clear day
        scene = WrapperScene.weather(scene: WeatherScene.scorchingSun);
      }
    } else if (wdes >= 801 && wdes <= 804) {
      if (isDay == false) {
        //cloudy night
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
        //cloudy day
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
