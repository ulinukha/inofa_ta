import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inofa/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddNumber {
  final String no_telp;
  AddNumber({this.no_telp});

  factory AddNumber.fromJson(Map<String, dynamic> json) {
    return AddNumber(
      no_telp: json['no_telp'],
    );
  }
}

class Number extends StatefulWidget{
  final Future<AddNumber> addNumber;
  Number({Key key, this.addNumber}) : super(key: key);
  @override
  _NumberState createState() => _NumberState();
}

class _NumberState extends State<Number>{

  final FocusNode _nodeNumber = FocusNode();
  TextEditingController numberControler = new TextEditingController();

  Future<AddNumber> _handleAddNumber(String no_telp) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    final http.Response response = await http.post(BaseUrl.noTelp+email, headers:<String, String>{
        'Content-Type': 'application/json; charset=UTF-8 ',
      },
      body: jsonEncode(<String, String>{
        'no_telp': no_telp,
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
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
            Center(
              child: Container(
                width: 280.0,
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
                AddNumber(no_telp: numberControler.text);
                Navigator.pushReplacementNamed(context, '/Otp');
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