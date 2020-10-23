import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/chat/add_skill_inovasi.dart';
import 'package:inofa/invite/mapsUser.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:inofa/models/requestJoin_models.dart';
import 'package:inofa/models/user_models.dart';
import 'package:inofa/notifikasi/requestJoinDetail.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailGroup extends StatefulWidget {
  final ListInovasi inovasis;
  final LoginUser userData;
  DetailGroup({Key key, this.inovasis, this.userData}) : super(key: key);
  @override
  _DetailGroupState createState() => _DetailGroupState();
}

class _DetailGroupState extends State<DetailGroup> {
  List<ListRequestJoin> _listRequest = [];
  List<UserModels> _listAnggota = [];
  var loading = false;

  Future<UserModels> _getListAnggota() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    final response = await http.get(
        BaseUrl.listMember + widget.inovasis.id_inovasi.toString(),
        headers: {
          'Authorization': 'Bearer ' + token,
        });
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        _listAnggota.add(UserModels.fromJson(i));
      }
    });
    loading = false;
  }

  Future<Null> _getListRequestJoin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    final response = await http.get(
        BaseUrl.listRequestJoin + widget.inovasis.id_inovasi.toString(),
        headers: {
          'Authorization': 'Bearer ' + token,
        });
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        _listRequest.add(ListRequestJoin.fromJson(i));
      }
    });
    loading = false;
  }

  @override
  void initState() {
    _getListAnggota();
    _getListRequestJoin();
    super.initState();
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
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    radius: 15,
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
                    dateFormat
                        .format(DateTime.parse(widget.inovasis.created_at)),
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
                          borderRadius:
                              new BorderRadius.all(Radius.circular(5))),
                      child: new Center(
                        child: new Text(
                          widget.inovasis.kategori.toString(),
                          style: TextStyle(fontSize: 10.0, color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 400,
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            side: BorderSide(color: Color(0xffECECEC))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddKemampuanInovasi(
                                  inovasis: widget.inovasis),
                            ),
                          );
                        },
                        color: Color(0xffECECEC),
                        textColor: Colors.black,
                        child: Text("Tambah kemampuan yang dicari",
                            style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Text(
                    'Permintaan Bergabung',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _requestList(),
                ],
              ),
            ),
            SizedBox(height: 25.0),
            Text(
              'Anggota',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15.0,
            ),
            admin(),
            _daftarAnggota(),
          ]),
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
            height: 45,
            margin: EdgeInsets.only(left: 24, right: 24, top: 5, bottom: 5),
            child: Container(
                child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                  side: BorderSide(color: Color(0xff2968E2))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapsUser(inovasis: widget.inovasis),
                  ),
                );
              },
              color: Color(0xff2968E2),
              textColor: Colors.white,
              child:
                  Text("Undang".toUpperCase(), style: TextStyle(fontSize: 15)),
            ))),
      ),
    );
  }

  Widget _requestList() {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _listRequest.length,
          itemBuilder: (context, i) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          RequstJoin(dataReq: _listRequest[i])));
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
                            child: Row(children: <Widget>[
                              Material(
                                child: Image.network(
                                  _listRequest[i].profile_picture,
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
                                width: 150,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: new Text(
                                          _listRequest[i].display_name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
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

  Widget admin() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(bottom: 10, left: 2, right: 2),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3.0)],
            borderRadius: new BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10),
                  margin: const EdgeInsets.only(right: 20.0),
                  child: Material(
                    child: Image.network(
                      widget.inovasis.profile_picture,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                ),
                Container(
                  width: 250,
                  child: Text(
                    widget.inovasis.display_name,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _daftarAnggota() {
    return _listAnggota.length == 0
        ? SizedBox()
        : Container(
            padding: EdgeInsets.all(2),
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: _listAnggota.length,
                itemBuilder: (context, i) {
                  return Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 3.0)
                          ],
                          borderRadius:
                              new BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                margin: const EdgeInsets.only(right: 20.0),
                                child: Material(
                                  child: Image.network(
                                    _listAnggota[i].profile_picture,
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                              ),
                              Container(
                                width: 250,
                                child: Text(
                                  _listAnggota[i].display_name,
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
  }
}
