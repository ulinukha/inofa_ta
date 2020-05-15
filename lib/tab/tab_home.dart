import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inofa/addIde/add_ide.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:inofa/models/kategori_model.dart';
import 'package:inofa/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/addIde/ide_detail.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget{
  Home({Key key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  List<ListKategori> _listKategori = [];
  List<ListInovasi> _listInovasi = [];
  List<ListInovasi> _listInovasiSearch = [];
  String latitude = ""; 
  String longitude = ""; 
  var loading = false;
  TextEditingController searchController = new TextEditingController();

  void _getCurrentLocation() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = "${position.latitude}";
      longitude = "${position.longitude}";
      updateLocation();
    });

  }

  updateLocation() async{
    final response = await http.post(BaseUrl.setLocation+'anggit@gmail.com',
      body: {
        "longitude":longitude,
        "latitude":latitude
    });
  }


  Future<Null> _getListKategori()async{
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.listKategori);
    final data1 = jsonDecode(response.body);

    setState(() {
      for(Map i in data1){
        _listKategori.add(ListKategori.fromJson(i));
        loading = false;
      }
    });
  }

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

  onSearch(String text) async{
    _listInovasiSearch.clear();
    if(text.isEmpty){
      setState(() {});
      return;
    }

    _listInovasi.forEach((f){
      if(f.judul.contains(text))
      _listInovasiSearch.add(f);
    });
    setState(() {});
  }

  Future<void> onRefresh() async{
    _getListInovasi();
  }

  void initState() {
    super.initState();
    _getCurrentLocation();
    _getListKategori();
    _getListInovasi();
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
        // centerTitle: true,
        elevation: 0.0,
        title: Text('Nama', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),

      body: loading?
        Center(
          child: CircularProgressIndicator(),
        ) : 
        RefreshIndicator( 
          onRefresh: onRefresh,
          child: Container(
            padding: EdgeInsets.only(top: 1),
              child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  search(),
                  Row(
                    children: <Widget>[
                      tagText(),
                      showAll(),
                    ]
                  ),
                  tagSlider(),
                  ideText(),
                  SizedBox(height: 10),
                  isiIde(),
                ],
              )
            ),
          ),        
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          backgroundColor: Color(0xff2968E2),
          onPressed: () {
            Navigator.push(
              context, MaterialPageRoute(builder: (context)=>AddIde(),
              ),
            );
          },
        ),
    );
  }

tagText(){
  return Container(
    padding: EdgeInsets.only(left: 24),
    child: Text('Tag', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
  );
}

showAll() {
  return Container(
    padding: EdgeInsets.only(left: 200),
    child: FlatButton(
      onPressed: () {},
      child: Text('Lihat Semua', style: TextStyle(fontSize: 12.0, color: Colors.black87),),
    )
  );
}

Widget tagSlider() {
  return Container(
    height: 110,
        padding: EdgeInsets.only(left:24.0),
        child: ListView.builder(
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: _listKategori.length,
          itemBuilder: (context, i){
            final tagKategori = _listKategori[i];
              return Container(
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.only(left:8.0, right: 8.0),

                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://www.gurupendidikan.co.id/wp-content/uploads/2019/11/Pengertian-Teknologi.jpg.webp',
                                
                                width: 130.0,
                            ),
                        ),
                        SizedBox(height:3.0),
                        Text(tagKategori.kategori)
                      ]
                    ),             
                  )
                ),
              );
          }
        )
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
                  color: Color(0xffE2E2E2),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearch,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ideText(){
    return Container(
      padding: EdgeInsets.only(left: 24),
      child: Text('Ide', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
    );
  }

  isiIde(){
    return Container(
      child: _listInovasiSearch.length != 0 || searchController.text.isNotEmpty?
      ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _listInovasiSearch.length,
        itemBuilder: (context, i){
          return Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context)=>IdeDetail(inovasis: _listInovasi[i]),
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
                            child: Image.asset(
                                'images/dev.jpg',
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
                                      Text(_listInovasiSearch[i].pengguna_id.toString(),
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
                              child: Image.asset(
                                  'images/dev.jpg',
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
                          child: Text(_listInovasiSearch[i].description
                          , style: TextStyle(fontSize: 12.0, color: Colors.black54),),
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
                                  _listInovasiSearch[i].kategori_id.toString(), 
                                  style: TextStyle(
                                    fontSize: 10.0, color: Colors.white
                                  ),
                                ),
                              )
                            ),
                          ),
                        ],
                      )
                    ]
                  ),
                ),
              ),
            ),
          );
        }
      )
      :
      ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _listInovasi.length,
        itemBuilder: (context, i){
          return Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context)=>IdeDetail(inovasis: _listInovasi[i]),
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
                            child: Image.asset(
                                'images/dev.jpg',
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
                                    child: new Text(_listInovasi[i].judul,
                                      style: TextStyle(fontSize: 14),
                                    ), 
                                  ),
                                  SizedBox(height:5),
                                  Row(
                                    children: <Widget> [
                                      Text(_listInovasi[i].pengguna_id.toString(),
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      SizedBox(width: 15),
                                      Text(dateFormat.format(DateTime.parse(_listInovasi[i].created_at)),
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
                              child: Image.asset(
                                  'images/dev.jpg',
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
                          child: Text(_listInovasi[i].tagline
                          , style: TextStyle(fontSize: 14.0),),
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 400,
                          child: Text(_listInovasi[i].description
                          , style: TextStyle(fontSize: 12.0, color: Colors.black54),),
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
                                  _listInovasi[i].kategori_id.toString(), 
                                  style: TextStyle(
                                    fontSize: 10.0, color: Colors.white
                                  ),
                                ),
                              )
                            ),
                          ),
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
    );
  }





}
