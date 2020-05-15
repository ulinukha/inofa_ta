import 'package:flutter/material.dart';

class Tes extends StatefulWidget {
  Tes({Key key, String display_name}) : super(key: key);
  _TesState createState() => _TesState();
}

class _TesState extends State<Tes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),      
    );
  }
}