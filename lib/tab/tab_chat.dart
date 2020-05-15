import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/chat/chat_screen.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/api/api.dart';

class Chat extends StatefulWidget{
  Chat({Key key}) : super(key: key);
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>{
  List<ListInovasi> _listInovasi = [];
  var loading = false;

  Future<Null> _getListInovasi()async{
    setState(() {
      loading = true;
    });
    _listInovasi.clear();
    final response = await http.get(BaseUrl.getInovasi);
    final data = jsonDecode(response.body);
    setState(() {
      for(Map i in data){
        _listInovasi.add(ListInovasi.fromJson(i));
        loading = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListInovasi();
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
        title: Text('Chat', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),

      body: loading? 
      Center(
        child: CircularProgressIndicator()
      ):
      Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _groupList(),
              SizedBox(height: 1.0)
            ],
          ),
        ),
      ),
    );
  }

  Widget _groupList(){
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _listInovasi.length,
        itemBuilder: (context, i){
          return Container(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(inovasis: _listInovasi[i])));
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
                        color: Colors.black,
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
                              child: Image.asset(
                                  'images/dev.jpg',
                                  width: 55.0,
                                  height: 55.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(55.0)),
                                clipBehavior: Clip.hardEdge,
                            ), 
                              Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                width: 235,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget> [
                                    Container(
                                      child: new Text(_listInovasi[i].judul,
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                      ), 
                                    ),
                                    SizedBox(height:5),
                                    Row(
                                      children: <Widget> [
                                        Text(_listInovasi[i].pengguna_id.toString(),
                                          style: TextStyle(fontSize: 13, color: Colors.grey),
                                        ),
                                        SizedBox(width: 15),
                                      ]
                                    ),
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
