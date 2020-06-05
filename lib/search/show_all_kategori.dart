import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inofa/models/kategori_model.dart';
import 'package:inofa/search/search_kategori.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inofa/api/api.dart';
import 'package:http/http.dart' as http;

class ShowAll extends StatefulWidget {
  @override
  _ShowAllState createState() => _ShowAllState();
}

class _ShowAllState extends State<ShowAll> {
  List<ListKategori> _listKategori = [];

  Future<Null> _getListKategori()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.get(BaseUrl.listKategori,
    headers: {
      'Authorization': 'Bearer '+ token,
    });
    final dataKategori = jsonDecode(response.body);
    if(this.mounted){
      setState(() {
        for(Map i in dataKategori){
          _listKategori.add(ListKategori.fromJson(i));
        }
      });
    }
  }

  @override
  void initState() {
    _getListKategori();
    super.initState();
  }

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
        title: Text('Kategori', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          children: List.generate(_listKategori.length, (i) {
            return Container(
              child: InkWell(
                onTap: (){
                  Navigator.push(
                  context, MaterialPageRoute(builder: (context)=>SearchKategori(inKategori: _listKategori[i]),
                  ),
                );
                },
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Material(
                            child: Image.network(
                                'https://www.gurupendidikan.co.id/wp-content/uploads/2019/11/Pengertian-Teknologi.jpg.webp',
                                width: 75.0,
                                height: 75.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                              clipBehavior: Clip.hardEdge,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(_listKategori[i].kategori,
                        style: TextStyle(fontSize: 14, color: Colors.black),)
                      ],
                    ),
                  )
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}