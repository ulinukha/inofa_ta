import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/models/kempuanUser_models.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:inofa/user_details/add_kemampuan.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  LoginUser _loginUser = null;
  List <KemampuanUser> _kemampuanUser =[];
  var loading = false;

  updateData()async{
    _loginUser = await LoginUser.getDataUser();
    if(mounted) setState(() {
      _getKemampuanUser();
    });
  }

  Future<Null> _getKemampuanUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.getKemampuan+_loginUser.user.id_pengguna.toString(),
    headers: {
      'Authorization': 'Bearer '+ token,
    });
    final dataKemampuan = jsonDecode(response.body);

    setState(() {
      for(Map i in dataKemampuan){
        _kemampuanUser.add(KemampuanUser.fromJson(i));
        loading = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  final dateFormat = new DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        title: Text('Profil', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),

      body: _loginUser ==null? 
        Center(
          child: CircularProgressIndicator()
        ): 
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
                            _loginUser.user.profile_picture,
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
                            _loginUser.user.display_name,
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
                        child: _loginUser.user.short_desc=='-'?SizedBox():
                        Text(_loginUser.user.short_desc, style: TextStyle(fontSize: 14),),
                      ),
                      SizedBox(height: 2),
                        _loginUser.user.website=='-'?SizedBox():
                      Text(_loginUser.user.website, style: TextStyle(fontSize: 14),),
                      SizedBox(height: 2),
                      _loginUser.user.tgl_lahir==null?Container():
                        Text(dateFormat.format(DateTime.parse(_loginUser.user.tgl_lahir.toString())), style: TextStyle(fontSize: 14),),
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
                        side: BorderSide(color: Color(0xffECECEC))),
                      onPressed: () {
                        Navigator.pushNamed(context, '/EditProfileOption');
                      },
                      color: Color(0xffECECEC),
                      textColor: Colors.black,
                      child: Text("Edit Profile".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
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
        Container(
          padding: EdgeInsets.only(top: 2, bottom: 10),
          child: Center(
            child: Container(
              width: 400,
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                  side: BorderSide(color: Color(0xfffcfcfc))),
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context)=>AddKemampuan(userData: _loginUser),
                    ),
                  );
                },
                color: Color(0xffECECEC),
                child: Image.asset('images/Add.png', width: 20,)
              ),
            ),
          ),
        ),
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
        Container(
          padding: EdgeInsets.only(top: 2, bottom: 10),
          child: Center(
            child: Container(
              width: 400,
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                  side: BorderSide(color: Color(0xfffcfcfc))),
                onPressed: () {
                  // Navigator.push(
                  //   context, MaterialPageRoute(builder: (context)=>AddKemampuan(userData: _loginUser),
                  //   ),
                  // );
                },
                color: Color(0xffECECEC),
                child: Image.asset('images/Add.png', width: 20,)
              ),
            ),
          ),
        ),
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


