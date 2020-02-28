import 'package:flutter/material.dart';

class Profile extends StatefulWidget{
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profil'),
      ),
    );
  }
}