import 'package:flutter/material.dart';
import './tab/tab_home.dart';
import './tab/tab_chat.dart';
import './tab/tab_notification.dart';
import './tab/tab_profile.dart';
import 'addIde/add_ide.dart';

class CurrentTab extends StatefulWidget{
  CurrentTab({Key key}) : super(key: key);
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

Widget currentScreen = Home();

final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
            ),
          ],
        ),
        child: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 90,
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
                          'images/Home.png', width: 27,
                          color: currentTab == 0 ? Color(0xff2968E2) : Color(0xff707070),
                        ),
                        SizedBox(height: 5.0,),
                        Text('Beranda',
                          style: TextStyle(fontSize: 12.0, color: currentTab == 0 ? Color(0xff2968E2) : Color(0xff707070)),
                        )
                        
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 90,
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
                          'images/Chat-2.png', width: 27,
                          color: currentTab == 1 ? Color(0xff2968E2) : Color(0xff707070),
                        ),
                        SizedBox(height: 5.0,),
                        Text('Pesan',
                          style: TextStyle(fontSize: 12.0, color: currentTab == 1 ? Color(0xff2968E2) : Color(0xff707070)),
                        )
                        
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 90,
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
                          'images/Notification.png', width: 27,
                          color: currentTab == 2 ? Color(0xff2968E2) : Color(0xff707070),
                        ),
                        SizedBox(height: 5.0,),
                        Text('Notifikasi',
                          style: TextStyle(fontSize: 12.0, color: currentTab == 2 ? Color(0xff2968E2) : Color(0xff707070)),
                        )
                        
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 90,
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
                          'images/Profile.png', width: 27,
                          color: currentTab == 3 ? Color(0xff2968E2) : Color(0xff707070),
                          
                        ),
                        SizedBox(height: 5.0,),
                        Text('Akun',
                          style: TextStyle(fontSize: 12.0, color: currentTab == 3 ? Color(0xff2968E2) : Color(0xff707070)),
                        )
                      ],
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
      ),

    );
  }
}
