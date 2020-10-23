import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:inofa/models/kempuanUser_models.dart';
import 'package:inofa/models/user_models.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InviteProfile extends StatefulWidget {
  final ListInovasi inovasis;
  final UserModels dataUser;
  InviteProfile ({Key key, this.inovasis, this.dataUser}) : super (key : key);
  _InviteProfileState createState() => _InviteProfileState();
}

class _InviteProfileState extends State<InviteProfile> {
  List <KemampuanUser> _kemampuanUser =[];
  var loading = false;

  Future<Null> _getKemampuanUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.getKemampuan+widget.dataUser.id_pengguna.toString(),
    headers: {
      'Authorization': 'Bearer '+ token,
    });
    final dataKemampuan = jsonDecode(response.body);

    setState(() {
      for(Map i in dataKemampuan){
        _kemampuanUser.add(KemampuanUser.fromJson(i));
      }
    });
    loading = false;
  }

  inviteUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(BaseUrl.inviteUserApi+widget.dataUser.id_pengguna.toString(), 
    headers: {
      'Authorization': 'Bearer '+ token,
    },
    body: {
      "pengguna_id" : widget.dataUser.id_pengguna.toString(),
      "inovasi_id" : widget.inovasis.id_inovasi.toString()
    });
    Navigator.pushReplacementNamed(context, '/CurrentTab');
  }

  @override
  void initState() {
    super.initState();
    _getKemampuanUser();
  }

  final dateFormat = new DateFormat('dd-MM-yyyy');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black,
          ),
        elevation: 0.0,
        title: Text('Profile', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),
      
      body: loading? 
      Center(
        child: CircularProgressIndicator(),
      ) :
      Container(
          padding: EdgeInsets.only(left: 24, right: 24, bottom: 5),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      margin: const EdgeInsets.only(right: 20.0),
                      child: Material(
                        child: Image.network(
                            widget.dataUser.profile_picture,
                            width: 75.0,
                            height: 75.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          clipBehavior: Clip.hardEdge,
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.dataUser.display_name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      )
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: new BoxConstraints(
                        maxHeight: 175.0,
                      ),
                        child: widget.dataUser.short_desc==null?Container():
                        Text(widget.dataUser.short_desc, style: TextStyle(fontSize: 14),),
                      ),
                      SizedBox(height: 2),
                        widget.dataUser.website==null?Container():
                      Text(widget.dataUser.website, style: TextStyle(fontSize: 14),),
                      SizedBox(height: 2),
                      widget.dataUser.tgl_lahir==null?Container():
                        Text(dateFormat.format(DateTime.parse(widget.dataUser.tgl_lahir.toString())), style: TextStyle(fontSize: 14),),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Container(
                    width: 400,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(0xff2968E2))),
                      onPressed: () {
                        inviteUser();
                      },
                      color: Color(0xff2968E2),
                      textColor: Colors.black,
                      child: Text("Undang".toUpperCase(),
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                  ),
                ),
                Expanded(child: _tabProfile()),
              ],
            ),
          ),
      ),
    );
  }

  Widget _tabProfile(){
    return Container(
      child: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: [
                Tab(text: 'Portofolio'),
                Tab(text: 'Kemampuan'),
                Tab(text: 'Pengalaman'),
              ],
              labelColor: Colors.black,
              labelStyle: TextStyle(fontSize: 12.0),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  tabViewPortofolio(),
                  tabViewKemampuan(),
                  tabViewPortofolio(),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tabViewPortofolio(){
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 1.0, right: 1),
        child: _listPortofolio(),
      ),
    );
  }

  Widget tabViewKemampuan(){
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 1.0, right: 1),
        child: _listKemampuan(),
      ),
    );
  }

  Widget tabViewPengalaman(){
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 1.0, right: 1),
        child: _listKemampuan(),
      ),
    );
  }

  Widget _listKemampuan(){
    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _kemampuanUser.length,
          itemBuilder: (context, i){
            return Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0
                    )
                  ],
                  borderRadius: new BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(_kemampuanUser[i].kemampuan)
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _listPortofolio(){
    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: 1,
          itemBuilder: (context, i){
            return Center(
              child: Text('Fitur Belum Tersedia',
              style: TextStyle(fontWeight: FontWeight.bold),),
            );
          },
        )
      ],
    );
  }

}
