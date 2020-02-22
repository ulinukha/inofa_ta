import 'package:flutter/material.dart';

class Notification extends StatefulWidget{
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification>{
  @override
  Widget build(BuildContext context){
    return new Container(
      child: new Center(
        child: new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(20.0),),
            new Text("Upload Ide", style: new TextStyle(fontSize: 30.0),),
            new Padding(padding: new EdgeInsets.all(20.0),),
            new Icon(Icons.headset, size:90.0,)
          ],
        ),
      ),
    );
  }
}