import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/chat/chat_screen.dart';
import 'package:inofa/chat/chat_screen_subscribe.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<ListInovasi> _listInovasi = [];
  List<ListInovasi> _listCreateInovasi = [];
  var loading = false;

  Future<Null> _getListInovasiInCreate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    final response =
        await http.get(BaseUrl.getInovasiInCreate + email, headers: {
      'Authorization': 'Bearer ' + token,
    });
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        _listCreateInovasi.add(ListInovasi.fromJson(i));
      }
    });
    loading = false;
  }

  Future<Null> _getListInovasiInJoin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    _listInovasi.clear();
    final response = await http.get(BaseUrl.getInovasiInJoin + email, headers: {
      'Authorization': 'Bearer ' + token,
    });
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        _listInovasi.add(ListInovasi.fromJson(i));
      }
    });
    loading = false;
  }

  @override
  void initState() {
    _getListInovasiInJoin();
    _getListInovasiInCreate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : _listInovasi.length == 0 && _listCreateInovasi.length == 0
              ? Center(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'images/EmptyGroup.png',
                        width: 300,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Tidak ada pesan',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _getInovasiDibuat(),
                        SizedBox(height: 1.0),
                        _groupList(),
                        SizedBox(height: 1.0)
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _getInovasiDibuat() {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _listCreateInovasi.length,
          itemBuilder: (context, i) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(inovasis: _listCreateInovasi[i])));
                },
                child: Container(
                  width: 400,
                  color: Colors.transparent,
                  child: new Container(
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Row(children: <Widget>[
                              Material(
                                child: Image.network(
                                  'http://192.168.43.10:8000/' +
                                      _listCreateInovasi[i].thumbnail,
                                  width: 55.0,
                                  height: 55.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                width: 235,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: new Text(
                                          _listCreateInovasi[i].judul,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ]),
                              ),
                            ]),
                          ),
                        ]),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _groupList() {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _listInovasi.length,
          itemBuilder: (context, i) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ChatScreenSub(inovasis: _listInovasi[i])));
                },
                child: Container(
                  width: 400,
                  color: Colors.transparent,
                  child: new Container(
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Row(children: <Widget>[
                              Material(
                                child: Image.network(
                                  'http://192.168.43.10:8000/' +
                                      _listInovasi[i].thumbnail,
                                  width: 55.0,
                                  height: 55.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                width: 235,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: new Text(
                                          _listInovasi[i].judul,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ]),
                              ),
                            ]),
                          ),
                        ]),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
