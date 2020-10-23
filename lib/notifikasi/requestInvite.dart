import 'package:flutter/material.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/models/invitation_models.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RequestInvite extends StatefulWidget {
  final ListInvitation dataInovasi;
  final LoginUser dataUser;
  RequestInvite({Key key, this.dataInovasi, this.dataUser}) : super(key: key);
  @override
  _RequestInviteState createState() => _RequestInviteState();
}

class _RequestInviteState extends State<RequestInvite> {
  accept() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(
        BaseUrl.acceptApi + widget.dataInovasi.inovasi_id.toString(),
        headers: {
          'Authorization': 'Bearer ' + token,
        },
        body: {
          "pengguna_id": widget.dataInovasi.pengguna_id.toString(),
          "inovasi_id": widget.dataInovasi.inovasi_id.toString()
        });
    Navigator.pushReplacementNamed(context, '/CurrentTab');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        title: Text(
          'Request',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Material(
                    child: Image.network(
                      'http://192.168.43.10:8000/' +
                          widget.dataInovasi.thumbnail,
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
                widget.dataInovasi.tagline,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Text(
                widget.dataInovasi.description,
                style: TextStyle(fontSize: 13.0, color: Colors.black),
              ),
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
                          borderRadius:
                              new BorderRadius.all(Radius.circular(5))),
                      child: new Center(
                        child: new Text(
                          widget.dataInovasi.kategori.toString(),
                          style: TextStyle(fontSize: 10.0, color: Colors.white),
                        ),
                      )),
                ),
                SizedBox(width: 15),
                Image.asset(
                  'images/Group.png',
                  width: 30,
                ),
                SizedBox(width: 5),
                Text(widget.dataInovasi.jumlah.toString()),
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
                  Row(children: <Widget>[
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
                        onPressed: () {
                          accept();
                        },
                        color: Color(0xff2968E2),
                        textColor: Colors.white,
                        child: Text("Gabung".toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ]),
                ]),
          )),
    );
  }
}
