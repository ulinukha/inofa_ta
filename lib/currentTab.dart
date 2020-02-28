import 'package:flutter/material.dart';
import './tab/tab_home.dart';
import './tab/tab_chat.dart';
import './tab/tab_notification.dart';
import './tab/tab_profile.dart';

class CurrentTab extends StatefulWidget{
  @override
  _CurrentTabState createState() => new _CurrentTabState();
}

class _CurrentTabState extends State<CurrentTab> with SingleTickerProviderStateMixin{

  int currentTab = 0;
  final List<Widget> screens = [
    Chat(),
    Home(),
    Notif(),
    Profile(),
  ];

Widget currentScreen = Chat();

final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff2968E2),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xffF3F3F3),
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 70,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Home(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/Home.png', width: 35,
                          color: currentTab == 0 ? Color(0xff2968E2) : Color(0xff8DADEA),
                          
                        ),
                        
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 70,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Chat(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/Chat-2.png', width: 35,
                          color: currentTab == 1 ? Color(0xff2968E2) : Color(0xff8DADEA),
                          
                        ),
                        
                      ],
                    ),
                  )
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 70,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Notif(); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/Notification.png', width: 35,
                          color: currentTab == 2 ? Color(0xff2968E2) : Color(0xff8DADEA),
                          
                        ),
                        
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 70,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Profile(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/Profile.png', width: 35,
                          color: currentTab == 3 ? Color(0xff2968E2) : Color(0xff8DADEA),
                          
                        ),
                      ],
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),

    );
  }
}
