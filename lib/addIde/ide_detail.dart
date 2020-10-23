import 'package:flutter/material.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdeDetail extends StatefulWidget {
  final LoginUser userData;
  final ListInovasi inovasis;
  IdeDetail({Key key, this.inovasis, this.userData}) : super(key: key);
  @override
  _IdeDetailState createState() => _IdeDetailState();
}

class _IdeDetailState extends State<IdeDetail> {
  joinInovasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(
        BaseUrl.joinInovasiApi + widget.userData.user.id_pengguna.toString(),
        headers: {
          'Authorization': 'Bearer ' + token,
        },
        body: {
          "pengguna_id": widget.userData.user.id_pengguna.toString(),
          "inovasi_id": widget.inovasis.id_inovasi.toString()
        });
    Navigator.pushReplacementNamed(context, '/CurrentTab');
  }

  final dateFormat = new DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        title: Text(
          widget.inovasis.judul,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: ListView(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(widget.inovasis.profile_picture),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Text(
                  widget.inovasis.display_name.toString(),
                  style: TextStyle(fontSize: 12.0, color: Colors.black),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Text(
                  dateFormat.format(DateTime.parse(widget.inovasis.created_at)),
                  style: TextStyle(fontSize: 12.0, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Container(
            child: Stack(
              children: <Widget>[
                Material(
                  child: Image.network(
                    'http://192.168.43.10:8000/' + widget.inovasis.thumbnail,
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
              widget.inovasis.tagline,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            child: Text(
              widget.inovasis.description,
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
                        borderRadius: new BorderRadius.all(Radius.circular(5))),
                    child: new Center(
                      child: new Text(
                        widget.inovasis.kategori.toString(),
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
              Text(widget.inovasis.jumlah.toString()),
            ],
          )
        ]),
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
          margin: EdgeInsets.only(left: 24, right: 24),
          child: RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
                side: BorderSide(color: Color(0xff2968E2))),
            onPressed: () {
              joinInovasi();
            },
            color: Color(0xff2968E2),
            textColor: Colors.white,
            child: Text("Gabung".toUpperCase(), style: TextStyle(fontSize: 15)),
          ),
        ),
      ),
    );
  }
}
