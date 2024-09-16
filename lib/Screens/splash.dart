import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pos_app/Screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const HomeScreen();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    height: 250,
                    width: 250,
                    image: AssetImage('assets/images/splash_logo.png'),
                  ),
                  Text(
                    "Twin Spider Private Limited",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Loading",
                  style: TextStyle(
                    color: Color.fromRGBO(49, 49, 49, 0.5),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(width: 5),
                SpinKitThreeInOut(
                  color: Colors.deepPurple,
                  size: 20,
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
