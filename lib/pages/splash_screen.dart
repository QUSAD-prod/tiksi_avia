import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiksi_avia/pages/avia_board_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const AviaBoardPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          getBackground(height, width),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.09),
                child: Image.asset(
                  "assets/tiksiAviaBig.png",
                  height: width * 0.32,
                  width: width * 0.32,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.03),
                child: SvgPicture.asset(
                  "assets/plane.svg",
                  width: width * 0.808,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tiksi ",
                      style: TextStyle(
                        fontSize: height * 0.055,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: "Poppins",
                      ),
                    ),
                    Text(
                      "Avia",
                      style: TextStyle(
                        fontSize: height * 0.055,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2e91c8),
                        fontFamily: "Poppins",
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Text(
                  "Онлайн табло самолётов и вертолётов",
                  style: TextStyle(
                    height: height * 0.0015,
                    fontSize: height * 0.03,
                    color: const Color(0xFF0C122A).withOpacity(0.6),
                    fontWeight: FontWeight.w300,
                    fontFamily: "Poppins",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(bottom: height * 0.04),
                child: Text(
                  "by Oslopov",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getBackground(double height, double width) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          color: const Color(0xFFD7E8F2),
        ),
        Container(
          width: width,
          height: height,
          padding: EdgeInsets.only(top: height * 0.04, bottom: height * 0.08),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: SvgPicture.asset(
              "assets/world_location_map.svg",
              color: const Color(0xFFD0E0EA),
            ),
          ),
        ),
      ],
    );
  }
}
