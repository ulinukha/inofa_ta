import 'package:flutter/material.dart';
import './otp_page.dart';

class Number extends StatefulWidget{
  _NumberState createState() => _NumberState();
}

class _NumberState extends State<Number>{
  final FocusNode _nodeNumber = FocusNode();



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
                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=> OtpPage()),
                );
              },
              child: Text(
                'Login With Google',
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