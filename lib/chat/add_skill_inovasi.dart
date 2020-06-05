import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:inofa/models/skill_models.dart';
import 'package:inofa/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddKemampuanInovasi extends StatefulWidget {
  final ListInovasi inovasis;
  AddKemampuanInovasi ({Key key, this.inovasis}):super(key:key);
  _AddKemampuanInovasiState createState() => _AddKemampuanInovasiState();
}

class _AddKemampuanInovasiState extends State<AddKemampuanInovasi> {


  List<ListSkill> _filterSkill = [];
  List<ListSkill> _listSkill = [];
  List<ListSkill> _listSkillSearch = [];
  var loading = false;
  String txtKemampuanId;
  TextEditingController searchController = new TextEditingController();

  Future<Null> _getListSkill() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    _listSkill.clear();
    final response = await http.get(BaseUrl.listSkill, 
    headers: {
      'Authorization': 'Bearer '+ token,
    },);
    final data = jsonDecode(response.body);
    setState(() {
      for(Map i in data){
        _listSkill.add(ListSkill.fromJson(i));
        loading = false;
      }
    });
  }


  tambahKemampuan()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(BaseUrl.addKemampuanInovasi+widget.inovasis.id_inovasi.toString(), 
    headers: {
      'Authorization': 'Bearer '+ token,
    },
    body: {
      "kemampuan_id" : txtKemampuanId,
      "inovasi_id" : widget.inovasis.id_inovasi.toString(),
    });
    if(response.statusCode ==200){
      Navigator.pushReplacementNamed(context, '/CurrentTab');
    }
  }

  onSearch(String text) async{
    _listSkillSearch.clear();
    if(text.isEmpty){
      setState(() {});
      return;
    }

    _listSkill.forEach((f){
      if(f.kemampuan.contains(text))
      _listSkillSearch.add(f);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getListSkill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: Text('Input Skill', style: TextStyle(
            color: Colors.black,
            ),
          ),
        ),

        body: Container(
            padding: EdgeInsets.only(top: 1),
            child: Column(
              children: <Widget>[
                search(),
                SizedBox(height: 10),
                Expanded(
                  child: _skillView(),
                )
              ]
            )
        )
    );
  }

    Widget _skillView(){
      return Container(
        child: _listSkillSearch.length !=0 || searchController.text.isNotEmpty? 
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _listSkillSearch.length,
          itemBuilder: (context, i){
            final searchSkills = _listSkillSearch[i];
            return Container(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    txtKemampuanId = _listSkillSearch[i].id_kemampuan.toString();
                    tambahKemampuan();
                  });
                },
                child: Container(
                  width: 400,
                  padding: EdgeInsets.only(left:24, right: 24, bottom:5, top: 1),
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3.0,
                        )
                      ],
                      borderRadius: new BorderRadius.all(Radius.circular(5))
                    ), 
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget> [
                            Text(searchSkills.kemampuan)
                          ]
                        )
                      ],
                    ),
                  ),
                )
              ),
            );
          }
        )
        :
        ListView.builder(
          itemCount: _listSkill.length,
          itemBuilder: (context, i){
            final skills = _listSkill[i];
            return Container(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    txtKemampuanId = _listSkill[i].id_kemampuan.toString();
                    tambahKemampuan();
                  });
                },
                child: Container(
                  width: 400,
                  padding: EdgeInsets.only(left:24, right: 24, bottom:5, top: 1),
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3.0, //extend the shadow
                        )
                      ],
                      borderRadius: new BorderRadius.all(Radius.circular(5))
                    ), 
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget> [
                            Text(skills.kemampuan)
                          ]
                        )
                      ],
                    ),
                  ),
                )
              ),
            );
          },
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
                  color: Color(0xffE2E2E2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
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


}