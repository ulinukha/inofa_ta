import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inofa/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget{
  SignIn({Key key}) : super(key: key);
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn>{
  
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading=false;
  Future<FirebaseUser> _handleSignIn() async {
    setState(() {
      loading=true;
    });
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    daftar(user.uid, user.displayName, user.photoUrl, user.email);
    return user;
  }

  daftar(String uid, String dispayName, String photoUrl, String email) async {
    final response = await http.post(BaseUrl.signUp, body: {
      "id" :uid,
      "display_name": dispayName,
      "profile_picture": photoUrl,
      "email": email,
    });
    
    final data = jsonDecode(response.body);
    String message = data['message'];
    String token = data['token'];
    String name = data['name'];
    if (message == 'User sudah terdaftar') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', '$email');
      setState(() {
        loading=false;
      });
      Navigator.pushReplacementNamed(context, '/Otp');
      print(message);
    } else if(message == 'Pengguna berhasil didaftarkan') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', '$email');
      prefs.setString('name', '$name');
      prefs.setString('token', '$token');
      setState(() {
        loading=false;
      });
      Navigator.pushReplacementNamed(context, '/updateProfile');
      print(message);
      
    }
    else{
      setState(() {
        loading=false;
      });
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image.asset('images/slider_3.png', width: 250,),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
              'Buat akunmu dan cari teman untuk \nmengembangkan inovasi yang kamu miliki.',
              style: TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              ),
            ),
          
          SizedBox(height: 10),
          Center(
            child: Text(
            "Kami akan menjaga segala informasi \npribadi yang anda miliki.",
            style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          ),
          SizedBox(height: 20),
          Center(
            child:loading?CircularProgressIndicator(): Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            elevation: 4.0,
            child: MaterialButton(
              minWidth: 270,
              splashColor: Colors.transparent,  
              highlightColor: Colors.transparent,
              onPressed: _handleSignIn,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Image.asset('images/google.png', width: 20,),
                SizedBox(width:10),
                Text(
                'Masuk menggunakan Google',
                  style: TextStyle(
                  color: Colors.black,
                  ),
                ),
                ]
              )
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Dengan masuk, kamu menyetujui \nKetentuan Layanan dan Kebijakan Privasi",
              style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black54),
              textAlign: TextAlign.left,
            ),
          ),
          ],
        ),
      ),
    );
  }
  
}

