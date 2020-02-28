import 'package:flutter/material.dart';

class Notif extends StatefulWidget{
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Notification'),
      ),
    );
  }
}