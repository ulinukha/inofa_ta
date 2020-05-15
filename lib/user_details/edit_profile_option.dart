import 'package:flutter/material.dart';

class EditProfileOption extends StatefulWidget {
  @override
  _EditProfileOptionState createState() => _EditProfileOptionState();
}

class _EditProfileOptionState extends State<EditProfileOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        title: Text('Edit Profil', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),

      body: Container(
        padding: EdgeInsets.only(top:24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 24),
              child: Text('Akun', 
                style: TextStyle(fontSize: 20, color: Colors.black),
              )
            ),
            SizedBox(height:10),
            Container(
              height: 60,
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/EditProfil');
                },
                child: Container(
                  padding: EdgeInsets.only(left:24, right:24),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 0.1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 250,
                        child: Row(
                          children: <Widget>[
                            Image.asset('images/Profile_dark.png', width: 30,),
                            SizedBox(width:25),
                            Text('Profil', style: TextStyle(fontSize: 18, color: Colors.black),),
                          ]
                        ),
                      ),
                      SizedBox(width:40),
                      Image.asset('images/arrow.png', width: 13,),
                    ],
                  )
                ),
              ),
            ),
            SizedBox(height:25),
            Container(
              padding: EdgeInsets.only(left: 24),
              child: Text('Info Lainnya', 
                style: TextStyle(fontSize: 20, color: Colors.black),
              )
            ),
            SizedBox(height:10),
            Container(
              height: 60,
              child: GestureDetector(
                onTap: (){},
                child: Container(
                  padding: EdgeInsets.only(left:24, right:24),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 0.1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 250,
                        child: Row(
                          children: <Widget>[
                            Image.asset('images/Privacy.png', width: 30,),
                      SizedBox(width:25),
                      Text('Kebijakan Privasi', style: TextStyle(fontSize: 18, color: Colors.black),),
                          ]
                        ),
                      ),
                      SizedBox(width:40),
                      Image.asset('images/arrow.png', width: 13,),
                    ],
                  )
                ),
              ),
            ),
            SizedBox(height:1),
            Container(
              height: 60,
              child: GestureDetector(
                onTap: (){},
                child: Container(
                  padding: EdgeInsets.only(left:24, right:24),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 0.1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 250,
                        child: Row(
                          children: <Widget>[
                            Image.asset('images/About.png', width: 30,),
                      SizedBox(width:25),
                      Text('Tentang Kami', style: TextStyle(fontSize: 18, color: Colors.black),),
                          ]
                        ),
                      ),
                      SizedBox(width:40),
                      Image.asset('images/arrow.png', width: 13,),
                    ],
                  )
                ),
              ),
            ),
            SizedBox(height:25),
            Center(
              child: Container(
                width: 300,
                height: 45,
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                    side: BorderSide(color: Color(0xffFF6143))),
                  onPressed: () {

                  },
                  color: Color(0xffFF6143),
                  textColor: Colors.black,
                  child: Text("Keluar".toUpperCase(),
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}