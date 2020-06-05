import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:inofa/models/skill_models.dart';
import 'package:inofa/api/api.dart';
import 'package:http/http.dart' as http;

class AddKemampuanStart extends StatefulWidget {
  final LoginUser userData;
  AddKemampuanStart ({Key key, this.userData}):super(key:key);
  _AddKemampuanStartState createState() => _AddKemampuanStartState();
}

class _AddKemampuanStartState extends State<AddKemampuanStart> {


  List<ListSkill> _filterSkill = [];
  List<ListSkill> _listSkill = [];
  List<ListSkill> _listSkillSearch = [];
  List<ListSkill> _kemampuanUser =[];
  var loading = false;
  String txtKemampuanId;
  TextEditingController searchController = new TextEditingController();

  Future<Null> _getListSkill() async{
    setState(() {
      loading = true;
    });
    _listSkill.clear();
    final response = await http.get(BaseUrl.listSkill, 
    headers: {
      'Authorization': 'Bearer '+ widget.userData.user.token,
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
    final response = await http.post(BaseUrl.getKemampuan+widget.userData.user.id_pengguna.toString(), 
    headers: {
      'Authorization': 'Bearer '+ widget.userData.user.token,
    },
    body: {
      "pengguna_id" : widget.userData.user.id_pengguna.toString(),
      "kemampuan_id" : txtKemampuanId
    });
    if(response.statusCode ==200){
      Navigator.pushReplacementNamed(context, '/CurrentTab');
    }
  }

  _getKemampuanUser()async{
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.getKemampuan+widget.userData.user.id_pengguna.toString(),
    headers: {
      'Authorization': 'Bearer '+ widget.userData.user.token,
    },);
    final dataKemampuan = jsonDecode(response.body);

    setState(() {
      for(Map i in dataKemampuan){
        _kemampuanUser.add(ListSkill.fromJson(i));
      }
    });
    loading = false;
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

  filterSkill(){
    _filterSkill = _listSkill.where((element) => !_kemampuanUser.contains(element)).toList();
    print(_filterSkill);
  }

  @override
  void initState() {
    super.initState();
    _getListSkill();
    _getKemampuanUser();
    filterSkill();
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