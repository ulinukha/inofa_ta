import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/addIde/ide_detail.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:inofa/models/kategori_model.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchKategori extends StatefulWidget {
  final ListKategori inKategori;
  final LoginUser userData;
  SearchKategori({Key key, this.inKategori, this.userData}) : super(key: key);
  _SearchKategoriState createState() => _SearchKategoriState();
}

class _SearchKategoriState extends State<SearchKategori> {
  var loading = false;
  List<ListInovasi> _listInovasi = [];
  List<ListInovasi> _inovasiThisKategori = [];

  Future<Null> _getListInovasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    _listInovasi.clear();
    final response = await http.get(BaseUrl.getInovasi, headers: {
      'Authorization': 'Bearer ' + token,
    });
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        _listInovasi.add(ListInovasi.fromJson(i));
      }
    });
    _inovasiThisKategori = _listInovasi
        .where((i) => i.kategori == widget.inKategori.kategori)
        .toList();
    print(_inovasiThisKategori);
    loading = false;
  }

  @override
  void initState() {
    _getListInovasi();
    super.initState();
  }

  final dateFormat = new DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 4,
        centerTitle: true,
        title: Text(
          widget.inKategori.kategori,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.only(top: 24, left: 24, right: 24),
              child: _inovasiThisKategori.length == 0
                  ? SizedBox()
                  : Column(
                      children: <Widget>[_inovasiList()],
                    ),
            ),
    );
  }

  _inovasiList() {
    return Container(
        child: Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _inovasiThisKategori.length,
          itemBuilder: (context, i) {
            return Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IdeDetail(
                        inovasis: _inovasiThisKategori[i],
                        userData: widget.userData,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 400,
                  padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  color: Colors.transparent,
                  child: new Container(
                    padding: EdgeInsets.all(7),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3.0, //extend the shadow
                          )
                        ],
                        borderRadius:
                            new BorderRadius.all(Radius.circular(10))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Material(
                              child: Image.network(
                                _inovasiThisKategori[i].profile_picture,
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              width: 245,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: new Text(
                                        _inovasiThisKategori[i].judul,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(children: <Widget>[
                                      Text(
                                        _inovasiThisKategori[i].display_name,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        dateFormat.format(DateTime.parse(
                                            _inovasiThisKategori[i]
                                                .created_at)),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ]),
                                  ]),
                            ),
                          ]),
                          SizedBox(height: 8),
                          Container(
                            child: Stack(
                              children: <Widget>[
                                Material(
                                  child: Image.network(
                                    'http://192.168.43.10:8000/' +
                                        _inovasiThisKategori[i].thumbnail,
                                    width: 400.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 400,
                            child: Text(
                              _inovasiThisKategori[i].tagline,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: 400,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _inovasiThisKategori[i].description,
                                  maxLines: _inovasiThisKategori[i].isSelected
                                      ? _inovasiThisKategori[i]
                                          .description
                                          .length
                                      : 2,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black54),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _inovasiThisKategori[i].isSelected =
                                          !_inovasiThisKategori[i].isSelected;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      _inovasiThisKategori[i].isSelected
                                          ? Text(
                                              "Perkecil",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                          : Text("Lanjut",
                                              style:
                                                  TextStyle(color: Colors.grey))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Container(
                                color: Colors.transparent,
                                child: new Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: new BoxDecoration(
                                        color: Color(0xff2968E2),
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(5))),
                                    child: new Center(
                                      child: new Text(
                                        _inovasiThisKategori[i].kategori,
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.white),
                                      ),
                                    )),
                              ),
                              SizedBox(width: 15),
                              Image.asset(
                                'images/Group.png',
                                width: 30,
                              ),
                              SizedBox(width: 5),
                              Text(_inovasiThisKategori[i].jumlah.toString()),
                            ],
                          )
                        ]),
                  ),
                ),
              ),
            );
          }),
    ));
  }
}
