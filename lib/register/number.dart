import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inofa/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/models/loginUser_models.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Number extends StatefulWidget{
  Number({Key key}) : super(key: key);
  @override
  _NumberState createState() => _NumberState();
}

class _NumberState extends State<Number>{
  LoginUser _loginUser = null;
  var loading = false;
  final FocusNode _nodeNumber = FocusNode();
  TextEditingController numberControler = new TextEditingController();
  final _key = new GlobalKey<FormState>();

  check(){
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      tambahNomor();
    }
  }

  tambahNomor()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    final response = await http.post(BaseUrl.noTelp+email, 
    headers: {
      'Authorization': 'Bearer '+ _loginUser.user.token,
    },
    body: {
      "no_telp" : numberControler.text,
    });
    Navigator.pushReplacementNamed(context, '/Otp');
  }

  updateData()async{
    setState(() {
      loading = true;
    });
    _loginUser = await LoginUser.getDataUser();
    if(mounted) setState(() {
    });
    loading = false;
    print(_loginUser.user.token);
  }

  @override
  void initState() {
    updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: loading?
      Center(
        child: CircularProgressIndicator()
      ) :
      Container(
        color: Colors.white,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 70.0, left: 10),
              child: Image.asset('images/inofa_logo.png', width: 60,),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
              'Masukkan nomor HP yang\nterdaftar',
              style: TextStyle(fontSize: 24, height: 1.5, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 30),
            Form(
              key : _key,
                          child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 45,
                      height: 45.0,
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
                      child: Center(child: Text('+62', style: TextStyle(fontSize: 16, color: Colors.black54),)),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: 220.0,
                      height: 50.0,
                      child: TextFormField(
                        // onSaved: (String value) {no_telp = value;},
                        controller: numberControler,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        focusNode: _nodeNumber,
                        decoration: InputDecoration(
                          hintText: 'Nomor HP',
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          Center(
            child: Material(
            color: Color(0xff2968E2),
            borderRadius: BorderRadius.circular(4.0),
            elevation: 4.0,
            child: MaterialButton(
              minWidth: 280,
              splashColor: Colors.transparent,  
              highlightColor: Colors.transparent,
              onPressed: () {
                check();
                // Navigator.pushReplacementNamed(context, '/Otp');
              },
              child: Text(
                'Masuk',
                style: TextStyle(
                   color: Colors.white,
                 ),),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
  
}