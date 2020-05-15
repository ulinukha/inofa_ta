import 'package:flutter/material.dart';
import 'package:inofa/models/user_models.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModels _userModels =  null;
  var loading = false;

  updateData()async{
    _userModels = await UserModels.getDataUser();
    if(mounted) setState(() {
      // _onVerifyCode(context, getNumber.no_telp);
    });
    print(_userModels);
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

      body: _userModels ==null? 
        Center(
          child: CircularProgressIndicator()
        ): 
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: <Widget> [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          child: Material(
                            color: Colors.white,
                                    child: Image.network(
                                        _userModels.profile_picture,
                                        width: 75.0,
                                        height: 75.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                      clipBehavior: Clip.hardEdge,
                                  ),
                        ),
                        //  Container(
                        //   width: 70,
                        //   child: GestureDetector(
                        //     onTap: () {},
                        //     child: Container(
                        //       child: Column(
                        //         children: <Widget>[
                        //           Text('5.0', style: TextStyle(fontWeight: FontWeight.bold),),
                        //           Text('Score'),
                        //         ],
                        //       ),
                        //     ),
                        //   )
                        // ),
                        // Container(
                        //   width: 70,
                        //   child: GestureDetector(
                        //     onTap: () {},
                        //     child: Container(
                        //       child: Column(
                        //         children: <Widget>[
                        //           Text('255', style: TextStyle(fontWeight: FontWeight.bold),),
                        //           Text('Pengikut'),
                        //         ],
                        //       ),
                        //     ),
                        //   )
                        // ),
                        // Container(
                        //   width: 70,
                        //   child: GestureDetector(
                        //     onTap: () {},
                        //     child: Container(
                        //       child: Column(
                        //         children: <Widget>[
                        //           Text('255',
                        //           style: TextStyle(fontWeight: FontWeight.bold),),
                        //           Text('Mengikuti'),
                        //         ],
                        //       ),
                        //     ),
                        //   )
                        // ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                _userModels.display_name,
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
                          _userModels.short_desc==null?Container():
                            Text(_userModels.short_desc, style: TextStyle(fontSize: 14),),
                          SizedBox(height: 2),
                            _userModels.website==null?Container():
                          Text(_userModels.website, style: TextStyle(fontSize: 14),),
                          SizedBox(height: 2),
                          _userModels.tgl_lahir==null?Container():
                            Text(dateFormat.format(DateTime.parse(_userModels.tgl_lahir.toString())), style: TextStyle(fontSize: 14),),
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
                    _tabProfile(),
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }
}

_tabProfile(){
  return Container(
    child: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Portofolio'), 
                  Tab(text: 'Kemampuan'),
                  Tab(text: 'Pengalaman'),
                ],
                labelColor: Colors.black,
                labelStyle: TextStyle(fontSize: 12.0),
              ),
              Container(
                  height: 300.0, 
                  child: TabBarView(
                    children: [
                      Center(child: Text('Portofolio')),
                      Center(child: Text('Kemampuan')),
                      Center(child: Text('Pengalaman')),
                      ],
                  ))
            ],
          ))
  );
}

