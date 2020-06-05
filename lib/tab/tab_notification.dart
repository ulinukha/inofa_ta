import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/models/invitation_models.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:inofa/models/requestJoin_models.dart';
import 'package:inofa/notifikasi/requestInvite.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/notifikasi/requestJoinDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notif extends StatefulWidget{
  Notif({Key key}) : super(key: key);
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif>{
  var loading = false;
  List<ListInvitation> _listInvitation = [];
  LoginUser _loginUser = null;

  updateData()async{
    _loginUser = await LoginUser.getDataUser();
    if(mounted) setState(() {
      _getListInvitation();
    });
  }

  Future<Null> _getListInvitation()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.listInvitedInovasi+_loginUser.user.id_pengguna.toString(),
    headers: {
      'Authorization': 'Bearer '+ token,
    });
    final dataInvitation = jsonDecode(response.body);
    setState(() {
      for(Map i in dataInvitation){
        _listInvitation.add(ListInvitation.fromJson(i));
      }
    });
    loading = false;
  }

  @override
  void initState() {
    updateData();
    super.initState();
  }

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
        title: Text('Notification', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),
      body: loading? 
      Center(
        child: CircularProgressIndicator()
      ):
      _listInvitation.length != 0 ? 
      Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _invitationList(),
              SizedBox(height: 1.0)
            ],
          ),
        ),
      )
      : Center(
          child: Column(
            children: <Widget>[
              Image.asset('images/EmptyNotifikasi.png', width: 300,),
              SizedBox(height: 15),
              Text('Tidak ada notifikasi', style: 
                TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _invitationList(){
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _listInvitation.length,
        itemBuilder: (context, i){
          return Container(
            child: GestureDetector(
              onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestInvite(dataInovasi: _listInvitation[i], dataUser: _loginUser)));
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
                    children: <Widget> [
                      Container(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Row(
                          children: <Widget> [
                            Material(
                              child: Image.network(
                                  'http://192.168.20.102:8000/'+_listInvitation[i].thumbnail,
                                  width: 55.0,
                                  height: 55.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(55.0)),
                                clipBehavior: Clip.hardEdge,
                            ), 
                              Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                width: 270,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget> [
                                    Container(
                                      child: new Text('Seseorang mengundang anda pada inovasi '+_listInvitation[i].judul,
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                      ), 
                                    ),
                                    SizedBox(height:5),
                                  ]
                                ),
                              ),
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
