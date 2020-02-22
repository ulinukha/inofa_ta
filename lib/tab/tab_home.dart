import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context){
    return new Container(
        child: new Column(
          children: <Widget>[
            
            new Padding(padding: new EdgeInsets.all(20.0),),
            new Text("Maps Teman", style: new TextStyle(fontSize: 30.0),),
            new Icon(Icons.smartphone, size:90.0,)
            
          ],
        ),
    );
  }
}