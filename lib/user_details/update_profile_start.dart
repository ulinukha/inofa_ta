import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/custom/datePicker.dart';
import 'package:inofa/models/allWilayah_models.dart';
import 'package:inofa/models/pendidikan_models.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geolocation;
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class UpdateProfileStart extends StatefulWidget {
  @override
  _UpdateProfileStartState createState() => _UpdateProfileStartState();
}

class _UpdateProfileStartState extends State<UpdateProfileStart> {
  var loading = false;
  final _key = new GlobalKey<FormState>();
  String display_name, txtTglLahir, pendidikan;
  TextEditingController txtDisplayName;
  List<ListPendidikan> _listPendidikan = [];
  List<AllWilayah> _listWilayah = [];
  Map<String, String> headers;
  String latitude = "";
  String longitude = "";
  String propinsi, idWilayah;

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
      });
    }
    updateLocation();
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

  update() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var names = prefs.getString('name');
    setState(() {
      txtDisplayName = TextEditingController(text: names);
      loading = false;
    });
  }

  Future<Null> _getListPendidikan() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response =
        await http.get(Uri.encodeFull(BaseUrl.listPendidikan), headers: {
      'Authorization': 'Bearer ' + token,
    });
    var data = json.decode(response.body);

    setState(() {
      for (Map i in data) {
        _listPendidikan.add(ListPendidikan.fromJson(i));
        loading = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    update();
    _getListPendidikan();
    _getCurrentLocation();
  }

  setup() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var displayName = prefs.getString('display_name');
    txtDisplayName = TextEditingController(text: displayName);
  }

  String pilihTanggal, labelTanggal;
  var formatTgl = new DateFormat('yyy-MM-dd');
  DateTime tgl = DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(1901),
        lastDate: DateTime(2199));

    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        txtTglLahir = formatTgl.format(tgl);
      });
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {
      showToast("Silakan lengkapi profil anda", Colors.red);
    }
  }

  submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var email = prefs.getString('email');
    final response = await http.post(BaseUrl.updateUser + email, headers: {
      'Authorization': 'Bearer ' + token,
    }, body: {
      "display_name": display_name,
      "pendidikan": pendidikan,
      "tgl_lahir": "$txtTglLahir",
      "website": '-',
      "no_telp": '1',
      "short_desc": '-',
    });
    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/Number');
      print('upload oke');
    }
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

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
          title: Text(
            'Input Profil',
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
                padding:
                    EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 5),
                child: Form(
                    key: _key,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          controller: txtDisplayName,
                          onSaved: (e) => display_name = e,
                          decoration: InputDecoration(labelText: 'Nama'),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Pendidikan',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        Container(
                          child: DropdownButton(
                            isExpanded: true,
                            items: _listPendidikan.map((pendidikans) {
                              return new DropdownMenuItem(
                                child:
                                    new Text(pendidikans.pendidikan.toString()),
                                value: pendidikans.id_Pendidikan.toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                pendidikan = newVal;
                                print(pendidikan);
                              });
                            },
                            hint: Text('Pendidikan'),
                            value: pendidikan,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Tanggal Lahir',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        DateDropDown(
                          labelText: labelTanggal,
                          valueText: formatTgl.format(tgl),
                          valueStyle: valueStyle,
                          onPressed: () {
                            _selectedDate(context);
                          },
                        ),
                        SizedBox(height: 25),
                        Center(
                          child: Container(
                            width: 300,
                            height: 45,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  side: BorderSide(color: Color(0xff2968E2))),
                              onPressed: () {
                                check();
                              },
                              color: Color(0xff2968E2),
                              textColor: Colors.black,
                              child: Text("Simpan".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ))));
  }
}
