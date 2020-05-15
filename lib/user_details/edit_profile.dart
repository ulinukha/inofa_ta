import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/custom/datePicker.dart';
import 'package:inofa/models/pendidikan_models.dart';
import 'package:inofa/models/user_models.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class EditProfil extends StatefulWidget {
  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  UserModels _userModels = null;
  var loading = false;
  final _key = new GlobalKey<FormState>();
  String display_name, no_telp, website, short_desc, txtTglLahir, pendidikan;
  TextEditingController txtDisplayName, txtNoTelp, txtWebsite, txtShortDesc;
  final FocusNode _nodeNumber = FocusNode();

  List <ListPendidikan> _listPendidikan = [];

  Future<String> _getListPendidikan() async{
    var response = await http.get(Uri.encodeFull(BaseUrl.listPendidikan), headers: {"Accept": "application/json"});
    var data = json.decode(response.body);

    setState(() {
      for(Map i in data){
        _listPendidikan.add(ListPendidikan.fromJson(i));
        loading=false;
      }
    });
  }

  updateData()async{
    setState(() {
      loading = true;
    });
    _userModels = await UserModels.getDataUser();
    if(mounted) setState(() {
    });
    setState(() {
      setup();
      loading=false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData();
    _getListPendidikan();
  }

  setup(){
    setState(() {
      loading = true;
    });
    txtTglLahir = _userModels.tgl_lahir;
    txtDisplayName = TextEditingController(text: _userModels.display_name);
    txtWebsite = TextEditingController(text: _userModels.website);
    txtNoTelp = TextEditingController(text: _userModels.no_telp);
    txtShortDesc = TextEditingController(text: _userModels.short_desc);
    
    loading = false;
  }

  String pilihTanggal, labelTanggal;
  DateTime tgl =  DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context, 
      initialDate: tgl, 
      firstDate: DateTime(1901), 
      lastDate: DateTime(2199)
    );

    if(picked != null && picked != tgl){
      setState(() {
        tgl = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl);
      });
    }
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
        title: Text('Edit Profil', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),
      
      body: _userModels == null? 
      Center(
        child: CircularProgressIndicator(),
      ):
      Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 2),
        child: Form(
          key: _key,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: txtDisplayName,
                onSaved: (e) => display_name = e,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                autofocus: false,
                focusNode: _nodeNumber,
                controller: txtNoTelp,
                onSaved: (e) => no_telp = e,
                decoration: InputDecoration(labelText: 'No Hp'),
              ),
              TextFormField(
                controller: txtWebsite,
                onSaved: (e) => website = e,
                decoration: InputDecoration(labelText: 'Website'),
              ),
              TextFormField(
                controller: txtShortDesc,
                onSaved: (e) => short_desc = e,
                decoration: InputDecoration(labelText: 'Short Desc'),
              ),
              SizedBox(height:15),
              Text('Pendidikan', style: TextStyle(fontSize: 15, color: Colors.black),),
              Container(
                child: DropdownButton(
                  isExpanded: true,
                  items: _listPendidikan.map((pendidikans){
                    return new DropdownMenuItem(
                      child: new Text(pendidikans.pendidikan.toString()),
                      value: pendidikans.id_Pendidikan.toString(),
                    );
                  }).toList(),
                  onChanged: (newVal){
                    setState(() {
                      pendidikan = newVal;
                      print(pendidikan);
                    });
                  },
                  hint: Text(_userModels.pendidikan == null? 'Pendidikan': _userModels.pendidikan.toString()),
                  value: pendidikan,
                ),
              ),
              SizedBox(height:15),
              Text('Tanggal Lahir', style: TextStyle(fontSize: 15, color: Colors.black),),
              DateDropDown(
                labelText: labelTanggal,
                valueText: _userModels.tgl_lahir ==null? new DateFormat.yMd().format(tgl):txtTglLahir,
                valueStyle: valueStyle,
                onPressed: (){
                  _selectedDate(context);
                },
              ),

              SizedBox(height:25),
              Center(
                child: Container(
                  width: 300,
                  height: 45,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                      side: BorderSide(color: Color(0xff2968E2))),
                    onPressed: () {
                      // print('pendidikan = ' + pendidikan);
                    },
                    color: Color(0xff2968E2),
                    textColor: Colors.black,
                    child: Text("Simpan".toUpperCase(),
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              ),
            ],
          )
        )
      )
    );
  }
}