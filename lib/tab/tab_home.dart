import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocation;
import 'package:inofa/addIde/add_ide.dart';
import 'package:inofa/models/allWilayah_models.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:inofa/models/kategori_model.dart';
import 'package:inofa/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/addIde/ide_detail.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:inofa/models/skill_models.dart';
import 'package:inofa/search/search_kategori.dart';
import 'package:inofa/search/search_screen.dart';
import 'package:inofa/search/show_all_kategori.dart';
import 'package:intl/intl.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ListKategori> _listKategori = [];
  List<ListInovasi> _listInovasiBySkill = [];
  List<ListInovasi> _listInovasi = [];
  List<AllWilayah> _listWilayah = [];
  List<ListSkill> _kemampuanUser = [];
  LoginUser _loginUser = null;
  String latitude = "";
  String longitude = "";
  String propinsi, idWilayah;
  var loading = false;
  TextEditingController searchController = new TextEditingController();

  void _getCurrentLocation() async {
    final position = await geolocation.Geolocator()
        .getCurrentPosition(desiredAccuracy: geolocation.LocationAccuracy.high);
    if (this.mounted) {
      setState(() {
        latitude = "${position.latitude}";
        longitude = "${position.longitude}";
      });
    }
    getUserLocation();
  }

  getUserLocation() async {
    final coordinates =
        new Coordinates(double.parse(latitude), double.parse(longitude));
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      propinsi = ('${first.adminArea}');
      print('${first.adminArea}');
    });
    _getListWilayah();
    return first;
  }

  updateData() async {
    setState(() {
      loading = true;
    });
    _loginUser = await LoginUser.getDataUser();
    if (mounted)
      setState(() {
        _getListInovasi();
        _getKemampuanUser();
      });
    setState(() {
      loading = false;
    });
  }

  Future<Null> _getListWilayah() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.wilayahApi, headers: {
      'Authorization': 'Bearer ' + token,
    });
    final dataWilayah = jsonDecode(response.body);
    setState(() {
      for (Map i in dataWilayah) {
        _listWilayah.add(AllWilayah.fromJson(i));
      }
    });
    List<AllWilayah> _filtered =
        _listWilayah.where((item) => item.propinsi == propinsi).toList();
    if (this.mounted && _filtered.length != 0) {
      setState(() {
        idWilayah = _filtered[0].id_wilayah.toString();
        updateLocation();
      });
    }
    loading = false;
  }

  updateLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var token = prefs.getString('token');
    final response = await http.post(BaseUrl.setLocation + email, headers: {
      'Authorization': 'Bearer ' + token,
    }, body: {
      "longitude": longitude,
      "latitude": latitude,
      "lokasi": '16',
    });
  }

  Future<Null> _getListKategori() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.get(BaseUrl.listKategori, headers: {
      'Authorization': 'Bearer ' + token,
    });
    final dataKategori = jsonDecode(response.body);
    if (this.mounted) {
      setState(() {
        for (Map i in dataKategori) {
          _listKategori.add(ListKategori.fromJson(i));
        }
      });
    }
  }

  Future<void> _getListInovasiBySkill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.get(
        BaseUrl.getInovasiBySkill + _kemampuanUser[0].id_kemampuan.toString(),
        headers: {
          'Authorization': 'Bearer ' + token,
        });
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        _listInovasiBySkill.add(ListInovasi.fromJson(i));
      }
    });
  }

  Future<void> _getListInovasi() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.getInovasi, headers: {
      'Authorization': 'Bearer ' + _loginUser.user.token,
    });
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        _listInovasi.add(ListInovasi.fromJson(i));
      }
    });
    loading = false;
  }

  _getKemampuanUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    final response = await http.get(
      BaseUrl.getKemampuan + _loginUser.user.id_pengguna.toString(),
      headers: {
        'Authorization': 'Bearer ' + token,
      },
    );
    final dataKemampuan = jsonDecode(response.body);

    setState(() {
      for (Map i in dataKemampuan) {
        _kemampuanUser.add(ListSkill.fromJson(i));
      }
    });
    if (this.mounted) {
      setState(() {
        _getListInovasiBySkill();
      });
    }
    loading = false;
  }

  void initState() {
    super.initState();
    updateData();
    _getCurrentLocation();
    _getListKategori();
  }

  final dateFormat = new DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        // centerTitle: true,
        elevation: 0.0,
        title: Text(
          'Inofa',
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
              padding: EdgeInsets.only(top: 1),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  search(),
                  Row(children: <Widget>[
                    tagText(),
                    showAll(),
                  ]),
                  tagSlider(),
                  ideText(),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 24),
                    child: Text(
                      'Rekomendasi',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  inovasiBySkill(),
                  Container(
                    padding: EdgeInsets.only(left: 24),
                    child: Text(
                      'Semua Inovasi',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  isiIde(),
                ],
              )),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff2968E2),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddIde(userData: _loginUser),
            ),
          );
        },
      ),
    );
  }

  tagText() {
    return Container(
      padding: EdgeInsets.only(left: 24),
      child: Text(
        'Tag',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
      ),
    );
  }

  showAll() {
    return Container(
        padding: EdgeInsets.only(left: 200),
        child: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowAll(userData: _loginUser),
              ),
            );
          },
          child: Text(
            'Lihat Semua',
            style: TextStyle(fontSize: 12.0, color: Colors.black87),
          ),
        ));
  }

  Widget tagSlider() {
    return Container(
        height: 110,
        padding: EdgeInsets.only(left: 24.0),
        child: ListView.builder(
            primary: false,
            scrollDirection: Axis.horizontal,
            itemCount: _listKategori.length,
            itemBuilder: (context, i) {
              final tagKategori = _listKategori[i];
              return Container(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchKategori(
                            inKategori: _listKategori[i],
                            userData: _loginUser,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            _listKategori[i].kategori_thumbnail,
                            width: 90.0,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(tagKategori.kategori)
                      ]),
                    )),
              );
            }));
  }

  search() {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      child: Row(
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 2),
              height: 40,
              width: 360,
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xffF6F6F7))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(userData: _loginUser),
                    ),
                  );
                },
                color: Color(0xffF6F6F7),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.search, color: Color(0xff818182)),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Cari ide..",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff818182))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ideText() {
    return Container(
      padding: EdgeInsets.only(left: 24),
      child: Text(
        'Ide',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
      ),
    );
  }

  inovasiBySkill() {
    return _listInovasiBySkill.length == 0
        ? SizedBox()
        : Container(
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: _listInovasiBySkill.length,
                itemBuilder: (context, i) {
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IdeDetail(
                                inovasis: _listInovasiBySkill[i],
                                userData: _loginUser),
                          ),
                        );
                      },
                      child: Container(
                        width: 400,
                        padding:
                            EdgeInsets.only(left: 24, right: 24, bottom: 24),
                        color: Colors.transparent,
                        child: new Container(
                          padding: EdgeInsets.all(7),
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3.0,
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
                                      _listInovasiBySkill[i].profile_picture,
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(45.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    width: 245,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: new Text(
                                              _listInovasiBySkill[i].judul,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(children: <Widget>[
                                            Text(
                                              _listInovasiBySkill[i]
                                                  .display_name,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              dateFormat.format(DateTime.parse(
                                                  _listInovasiBySkill[i]
                                                      .created_at)),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
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
                                              _listInovasiBySkill[i].thumbnail,
                                          width: 400.0,
                                          height: 100.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        clipBehavior: Clip.hardEdge,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: 400,
                                  child: Text(
                                    _listInovasiBySkill[i].tagline,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  width: 400,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _listInovasiBySkill[i].description,
                                        maxLines:
                                            _listInovasiBySkill[i].isSelected
                                                ? _listInovasiBySkill[i]
                                                    .description
                                                    .length
                                                : 2,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _listInovasiBySkill[i].isSelected =
                                                !_listInovasiBySkill[i]
                                                    .isSelected;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            _listInovasiBySkill[i].isSelected
                                                ? Text(
                                                    "Perkecil",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14),
                                                  )
                                                : Text("Lanjut",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14))
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
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(5))),
                                          child: new Center(
                                            child: new Text(
                                              _listInovasiBySkill[i].kategori,
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
                                    Text(_listInovasiBySkill[i]
                                        .jumlah
                                        .toString()),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }

  isiIde() {
    return _listInovasi.length == 0
        ? SizedBox()
        : Container(
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: _listInovasi.length,
                itemBuilder: (context, i) {
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IdeDetail(
                                inovasis: _listInovasi[i],
                                userData: _loginUser),
                          ),
                        );
                      },
                      child: Container(
                        width: 400,
                        padding:
                            EdgeInsets.only(left: 24, right: 24, bottom: 24),
                        color: Colors.transparent,
                        child: new Container(
                          padding: EdgeInsets.all(7),
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3.0,
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
                                      _listInovasi[i].profile_picture,
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(45.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    width: 245,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: new Text(
                                              _listInovasi[i].judul,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(children: <Widget>[
                                            Text(
                                              _listInovasi[i].display_name,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              dateFormat.format(DateTime.parse(
                                                  _listInovasi[i].created_at)),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
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
                                              _listInovasi[i].thumbnail,
                                          width: 400.0,
                                          height: 100.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        clipBehavior: Clip.hardEdge,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: 400,
                                  child: Text(
                                    _listInovasi[i].tagline,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  width: 400,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _listInovasi[i].description,
                                        maxLines: _listInovasi[i].isSelected
                                            ? _listInovasi[i].description.length
                                            : 2,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black54),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _listInovasi[i].isSelected =
                                                !_listInovasi[i].isSelected;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            _listInovasi[i].isSelected
                                                ? Text(
                                                    "Perkecil",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                : Text("Lanjut",
                                                    style: TextStyle(
                                                        color: Colors.grey))
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
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(5))),
                                          child: new Center(
                                            child: new Text(
                                              _listInovasi[i].kategori,
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
                                    Text(_listInovasi[i].jumlah.toString()),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
