import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
      ),
    );
  }
}