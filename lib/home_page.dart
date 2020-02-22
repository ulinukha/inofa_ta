import 'package:flutter/material.dart';
import './tab/tab_home.dart' as home;
import './tab/tab_chat.dart' as chat;
import './tab/tab_notification.dart' as notification;
import './tab/tab_profile.dart' as profile;

class Home extends StatefulWidget{
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

TabController controller;

@override
  void initState(){
    controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
    void dispose(){
      controller.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      // appBar: new AppBar(
      //   backgroundColor: Colors.white,
      //   title: new Text("Loren", style: TextStyle(color: Colors.black, fontSize: 18.0)),
      //   elevation: 0.0,
      // ),
      
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new home.Home(),
          new chat.Chat(),
          new notification.Notification(),
          new profile.Profile()
        ],
      ),

      bottomNavigationBar: new Material(
        color: Color(0xffdedede),
        child: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(icon: new Image.asset(
                  "images/home_on.png",
                  width: 25)),
            new Tab(icon: new Image.asset(
                  "images/chat_on.png",
                  width: 25)),
            new Tab(icon: new Image.asset(
                  "images/notif_on.png",
                  width: 25)),
            new Tab(icon: new Image.asset(
                  "images/profil_on.png",
                  width: 25)),
          ]
        ),
      )
    );
  }
}
