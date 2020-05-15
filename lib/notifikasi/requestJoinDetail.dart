import 'package:flutter/material.dart';
import 'package:inofa/tab/tab_profile.dart';

class RequstJoin extends StatefulWidget {
  RequstJoin ({Key key}) : super(key : key);
  @override
  _RequstJoinState createState() => _RequstJoinState();
}

class _RequstJoinState extends State<RequstJoin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black,
          ),
        elevation: 0.0,
        title: Text('Request', style: TextStyle(
          color: Colors.black,
          ),
        ),
        
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: <Widget>[
            // SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  child: Image.asset(
                      'images/dev.jpg',
                      width: 70.0,
                      height: 70.0,
                      fit: BoxFit.cover,
                    ),
                  borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                 Container(
                  width: 70,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => Number(),
                      //       ),
                      // );
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text('5.0', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Score'),
                        ],
                      ),
                    ),
                  )
                ),
                Container(
                  width: 70,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => Number(),
                      //       ),
                      // );
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text('255', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Pengikut'),
                        ],
                      ),
                    ),
                  )
                ),
                Container(
                  width: 70,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => Number(),
                      //       ),
                      // );
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text('255',
                          style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Mengikuti'),
                        ],
                      ),
                    ),
                  )
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('user.userName',
                style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 10.0),
          _tabProfile(),
          ],
        ),
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
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
              children: <Widget> [
                Container(
                  width: 130,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(0xff2968E2))),
                      onPressed: () {},
                      color: Color(0xff2968E2),
                      textColor: Colors.white,
                      child: Text("Tolak".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                  width: 130,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(0xff2968E2))),
                      onPressed: () {},
                      color: Color(0xff2968E2),
                      textColor: Colors.white,
                      child: Text("Izinkan".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ]
              ),
            ]
          ),
        )
      ),
      
    );
  }
}

_tabProfile(){
  return Container(
    child: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Portofolio'), 
                  Tab(text: 'Kemampuan'),
                  Tab(text: 'Pengalaman'),
                ],
                labelColor: Colors.black,
                labelStyle: TextStyle(fontSize: 12.0),
              ),
              Container(
                  height: 300.0, 
                  child: TabBarView(
                    children: [
                      Center(child: Text('Portofolio')),
                      Center(child: Text('Kemampuan')),
                      Center(child: Text('Pengalaman')),
                      ],
                  ))
            ],
          ))
  );
}