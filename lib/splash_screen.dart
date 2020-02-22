import 'package:flutter/material.dart';
import 'package:inofa/slider_page.dart';
import 'dart:async';

class MyApp extends StatefulWidget{
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(context,
         MaterialPageRoute(builder: (context) => SliderPage(),
         ),
         );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              new Image.asset(
                  "images/inofa_logo.png",
                  width: 150,),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
            ),
            Text(
              "INOFA",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
  
}