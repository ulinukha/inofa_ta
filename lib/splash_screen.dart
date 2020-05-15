import 'package:flutter/material.dart';
import 'dart:async';

class SplachScreen extends StatefulWidget{
  SplachScreen({Key key}) : super(key: key);
  _SplachScreenState createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen>{

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
        // Navigator.pushReplacementNamed(context, '/Onboarding');
        Navigator.pushReplacementNamed(context, '/CurrentTab');
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