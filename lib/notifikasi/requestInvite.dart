import 'package:flutter/material.dart';
import 'package:inofa/tab/tab_profile.dart';

class RequestInvite extends StatefulWidget {
  RequestInvite ({Key key}) : super(key : key);
  @override
  _RequestInviteState createState() => _RequestInviteState();
}

class _RequestInviteState extends State<RequestInvite> {
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
            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('images/dev.jpg'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    'Samantha Ariva',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black
                    ),),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    '02/03/2020',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black
                    ),),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              child: Stack(
                children: <Widget>[
                  Material(
                    child: Image.asset(
                        'images/dev.jpg',
                        width: 400.0,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
              , style: TextStyle(
                fontSize: 13.0,
                color: Colors.black
              ),),
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: new Container(
                    padding: EdgeInsets.all(7),
                    decoration: new BoxDecoration(
                      color: Color(0xff2968E2),
                      borderRadius: new BorderRadius.all(Radius.circular(5))
                    ),
                    child: new Center(
                      child: new Text(
                        "Ekonomi", 
                        style: TextStyle(
                          fontSize: 10.0, color: Colors.white
                        ),
                      ),
                    )
                  ),
                ),
              ],
            )
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
                      child: Text("Gabung".toUpperCase(),
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
