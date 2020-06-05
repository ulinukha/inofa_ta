import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/addIde/ide_detail.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen ({Key key}) : super (key : key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  List<ListInovasi> _listInovasi = [];
  List<ListInovasi> _listInovasiSearch = [];
  var loading = false;

  Future<Null> _getListInovasi()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    _listInovasi.clear();
    final response = await http.get(BaseUrl.getInovasi,
    headers: {
      'Authorization': 'Bearer '+ token,
    });
    final data = jsonDecode(response.body);
    setState(() {
      for(Map i in data){
        _listInovasi.add(ListInovasi.fromJson(i));
      }
    });
    loading = false;
  }

  onSearch(text) async{
    _listInovasiSearch.clear();
    if(text.isEmpty){
      setState(() {});
      return;
    }

    _listInovasi.forEach((f){
      if(f.judul.contains(text) || f.kategori.contains(text))
      _listInovasiSearch.add(f);
    });
    setState(() {});
  }
  

  @override
  void initState() {
    super.initState();
    _getListInovasi();
  }

  final dateFormat = new DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        title: Text('', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),
      body: loading?
      Center(
        child: CircularProgressIndicator(),
      ):
      Container(
        padding: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: <Widget>[
            search(),
            SizedBox(height:20),
            searchController.text == ''? SizedBox() : _inovasiList()
          ],
        ),
      ),
    );
  }

  search() {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F7),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearch,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Cari ide..",
                    hintStyle: TextStyle(fontSize: 14, color: Color(0xff818182)),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Color(0xff818182))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _inovasiList(){
    return Container(
      child: _listInovasiSearch.length != 0?
      Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _listInovasiSearch.length,
          itemBuilder: (context, i){
            return Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context)=>IdeDetail(inovasis: _listInovasiSearch[i]),
                    ),
                  );
                },
                child: Container(
                  width: 400,
                  padding: EdgeInsets.only(left:24, right: 24, bottom: 24),
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
                      borderRadius: new BorderRadius.all(Radius.circular(10))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        Row(
                          children: <Widget> [
                            Material(
                              child: Image.network(
                                  _listInovasiSearch[i].profile_picture,
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                                clipBehavior: Clip.hardEdge,
                            ), 
                            Container(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              width: 245,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget> [
                                  Container(
                                    child: new Text(_listInovasiSearch[i].judul,
                                      style: TextStyle(fontSize: 14),
                                    ), 
                                  ),
                                  SizedBox(height:5),
                                  Row(
                                    children: <Widget> [
                                      Text(_listInovasiSearch[i].display_name,
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      SizedBox(width: 15),
                                      Text(dateFormat.format(DateTime.parse(_listInovasiSearch[i].created_at)),
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ]
                                  ),
                                ]
                              ),
                            ),
                          ]
                        ),
                        SizedBox(height: 8),
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Material(
                                child: Image.network(
                                    'http://192.168.20.102:8000/'+_listInovasiSearch[i].thumbnail,
                                    width: 400.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 400,
                            child: Text(_listInovasiSearch[i].tagline
                            , style: TextStyle(fontSize: 14.0),),
                        ),
                        SizedBox(height: 4),
                        Container(
                        width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(_listInovasiSearch[i].description,
                                maxLines: _listInovasiSearch[i].isSelected ? _listInovasiSearch[i].description.length : 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis, 
                                style: TextStyle(fontSize: 12.0, color: Colors.black54),
                              ),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    _listInovasiSearch[i].isSelected = !_listInovasiSearch[i].isSelected;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    _listInovasiSearch[i].isSelected ? Text("Perkecil",style: TextStyle(color: Colors.grey),) :  Text("Lanjut",style: TextStyle(color: Colors.grey))
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
                                  borderRadius: new BorderRadius.all(Radius.circular(5))
                                ),
                                child: new Center(
                                  child: new Text(
                                    _listInovasiSearch[i].kategori, 
                                    style: TextStyle(
                                      fontSize: 10.0, color: Colors.white
                                    ),
                                  ),
                                )
                              ),
                            ),
                            SizedBox(width: 15),
                            Image.asset('images/Group.png', width: 30,),
                            SizedBox(width: 5),
                            Text(_listInovasiSearch[i].jumlah.toString()),
                          ],
                        )
                      ]
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ) :
      Center(
        child: Column(
          children: <Widget>[
            Image.asset('images/NoInovasi.png', width: 300,),
            SizedBox(height: 15),
            Text('Ide Tidak Ditemukan', style: 
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
}