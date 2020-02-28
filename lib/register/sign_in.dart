import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './number.dart';

class SignIn extends StatefulWidget{
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn>{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new Number(),
      ),
    );
    return user;
  }

  signOut() {
    _googleSignIn.signOut();
    _auth.signOut();
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
              'Lorem Ipsum is simply dummy \ntext of the printing',
              style: TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              ),
            ),
          
          SizedBox(height: 10),
          Center(
            child: Text(
            "Lorem Ipsum has been the industry's \nstandard dummy text ever since the 1500s",
            style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          ),
          SizedBox(height: 20),
          Center(
            child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            elevation: 4.0,
            child: MaterialButton(
              minWidth: 270,
              splashColor: Colors.transparent,  
              highlightColor: Colors.transparent,
              onPressed: _handleSignIn,
              child: Text(
                'Login With Google',
                style: TextStyle(
                   color: Colors.black,
                 ),),
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