import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetNumber {
  final String no_telp;

  GetNumber({this.no_telp});

  factory GetNumber.fromJson(Map<String, dynamic> json) {
    return GetNumber(
      no_telp: json['no_telp'],
    );
  }
  static Future<GetNumber> getNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var response = await http.get(BaseUrl.dataUser+email);
    var jsonObject = json.decode(response.body);
    var userData = (jsonObject as Map<String, dynamic>);

    return GetNumber.fromJson(userData);
  }
}

class OtpScreen extends StatefulWidget{
  OtpScreen ({Key key}): super(key:key);
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>{
  List<String> currentOtp = ["","","","","",""];
  TextEditingController otpOneController = TextEditingController();
  TextEditingController otpTwoController = TextEditingController();
  TextEditingController otpThreeController = TextEditingController();
  TextEditingController otpFourController = TextEditingController();
  TextEditingController otpFiveController = TextEditingController();
  TextEditingController otpSixController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.transparent),
  );

  int otpIndex =0;

  GetNumber getNumber=null;

  updateNumber()async{
    getNumber = await GetNumber.getNo();
    if(mounted) setState(() {
      // _onVerifyCode(context, getNumber.no_telp);
    });
  }


  FirebaseApp app;
  Future<void> _handleSignOut() async {
    app = await FirebaseApp.configure(
      name: 'test1',
      options: Platform.isAndroid
          ? FirebaseOptions(
              googleAppID: '1:1051653715401:android:21f960d090fea917012418',
              apiKey: 'AIzaSyD1Dk4baQLz0QshslXVzepo7B5KzcDjt4U',
              projectID: 'inova-ta',
            )
          : FirebaseOptions(
              googleAppID: 'url.googleAppIdIoS',
              gcmSenderID: 'url.gcmSenderId',
              apiKey: 'url.apiKeyIoS',
              projectID: 'url.projectId',
            ),
    );
    _auth = FirebaseAuth.fromApp(app);
    await _auth.signOut();
    print('SIGN OUT');
    _onVerifyCode();
  }

  @override
  void initState() {
    super.initState();
    print('IN OTP PAGE');
    // updateNumber();
    // _handleSignOut();
  }

  bool isCodeSent = false;
  String _verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      print(phoneAuthCredential);
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      print('SMS TERKIRIM');
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _auth.verifyPhoneNumber(
        phoneNumber: "+12252553050",
        timeout: const Duration(minutes: 2),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode:stringCode);

    _auth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        print(value.user.phoneNumber);
        Navigator.pushReplacementNamed(context, '/Home');
      } else {
        showToast("Error validating OTP, try again", Colors.red);
      }
    });
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment(0, 0.5),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 60.0),
                    buildTitleText(),
                    SizedBox(height: 5.0),
                    buildDescriptionText(),
                    SizedBox(height: 30.0),
                    buildPinRow(),
                    SizedBox(height: 30.0),
                    buildNumberPad(),
                  ]
                ),
            ),
            ),
            buildButtonVerification(),
            SizedBox(height: 10.0),
            buildSendOtpText(),
            SizedBox(height: 20.0),
          ],
        ),
      ) 
    );
  }

  buildNumberPad(){
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom:32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n: 1,
                    onPressed:() {
                      otpIndexSetup("1");
                    },
                  ),
                  KeyboardNumber(
                    n: 2,
                    onPressed:() {
                      otpIndexSetup("2");
                    },
                  ),
                  KeyboardNumber(
                    n: 3,
                    onPressed:() {
                      otpIndexSetup("3");
                    },
                  ), 
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n: 4,
                    onPressed:() {
                      otpIndexSetup("4");
                    },
                  ),
                  KeyboardNumber(
                    n: 5,
                    onPressed:() {
                      otpIndexSetup("5");
                    },
                  ),
                  KeyboardNumber(
                    n: 6,
                    onPressed:() {
                      otpIndexSetup("6");
                    },
                  ), 
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                    n: 7,
                    onPressed:() {
                      otpIndexSetup("7");
                    },
                  ),
                  KeyboardNumber(
                    n: 8,
                    onPressed:() {
                      otpIndexSetup("8");
                    },
                  ),
                  KeyboardNumber(
                    n: 9,
                    onPressed:() {
                      otpIndexSetup("9");
                    },
                  ), 
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 50.0,
                    child: MaterialButton(
                      onPressed: null,
                      child: SizedBox()
                    ,),
                  ),
                  KeyboardNumber(
                    n: 0,
                    onPressed:() {
                      otpIndexSetup("0");
                    },
                  ),
                  Container(
                    width: 50.0,
                    child: MaterialButton(
                      height: 50.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)
                      ),
                      onPressed: () {
                        clearOtp();
                      },
                      child: Image.asset('images/delete.png',
                      color: Color(0xff2968E2)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  clearOtp() {
    if(otpIndex == 0)
      otpIndex = 0;
    else if (otpIndex == 6){
      setOtp(otpIndex, "");
      currentOtp[otpIndex - 1] = "";
      otpIndex--;
    }else {
      setOtp(otpIndex, "");
      currentOtp[otpIndex - 1] = "";
      otpIndex--;
    }
  }

  String stringCode=  '';
  otpIndexSetup(String text) {
    if(otpIndex == 0)
    otpIndex = 1;
  else if(otpIndex < 6)
    otpIndex++;
    setOtp(otpIndex, text);
    currentOtp[otpIndex-1] = text;
    String inputCode = "";
    currentOtp.forEach((e){
      inputCode += e;
    });
    setState(() {
      stringCode = inputCode;
    });

    if(otpIndex == 6){   
      print('Inpit COde : '+inputCode);
      print('stringCode: ' + stringCode);
    }
  }

  setOtp(int n, String text) {
    switch(n) {
      case 1:
      otpOneController.text = text; break;
      case 2:
      otpTwoController.text = text; break;
      case 3:
      otpThreeController.text = text; break;
      case 4:
      otpFourController.text = text; break;
      case 5:
      otpFiveController.text = text; break;
      case 6:
      otpSixController.text = text; break;

    }
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PINNumber(
          outlineInputBorder : outlineInputBorder,
          textEditingController: otpOneController,
          ),
        PINNumber(
          outlineInputBorder : outlineInputBorder,
          textEditingController: otpTwoController,
          ),
        PINNumber(
          outlineInputBorder : outlineInputBorder,
          textEditingController: otpThreeController,
          ),
        PINNumber(
          outlineInputBorder : outlineInputBorder,
          textEditingController: otpFourController,
          ),
        PINNumber(
          outlineInputBorder : outlineInputBorder,
          textEditingController: otpFiveController,
          ),
        PINNumber(
          outlineInputBorder : outlineInputBorder,
          textEditingController: otpSixController,
          ),
      ],
    );
  }

  buildTitleText() {
    return Text(
      "Masukan kode verifikasi", 
      style: TextStyle(color: Colors.black87,
      fontSize: 21.0,
      fontWeight: FontWeight.bold,  ),
      );
  }

  buildDescriptionText() {
      return Column(
        children: <Widget>[
          Text(
            "Kode verifikasi telah dikirim pada", 
                style: TextStyle(color: Colors.grey,
                fontSize: 14.0, 
                ),
                textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "nomor ", 
                style: TextStyle(color: Colors.grey,
                fontSize: 14.0, 
                ),
                textAlign: TextAlign.center,
              ),
              Text(getNumber==null?'':getNumber.no_telp,
                style: TextStyle(color: Color(0xff2968E2),
                fontSize: 14.0, 
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
    );
  }


  buildSendOtpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Tidak menerima OTP?", 
          style: TextStyle(color: Colors.grey,
          fontSize: 14.0, 
          ),
        ),
        FlatButton(
              onPressed: () {},
              child: Text(
                'Kirim Ulang',
                style: TextStyle(color: Colors.red, fontSize: 14.0, fontWeight: FontWeight.w600),
                ),
            ),
      ],
    );
  }


  buildButtonVerification() {
    return Center(
            child: Material(
            color: Color(0xff2968E2),
            borderRadius: BorderRadius.circular(4.0),
            elevation: 4.0,
            child: MaterialButton(
              minWidth: 280,
              splashColor: Colors.transparent,  
              highlightColor: Colors.transparent,
              onPressed: _onFormSubmitted,
              child: Text(
                'Verifikasi',
                style: TextStyle(
                   color: Colors.white,
                 ),),
              ),
            ),
          );
  }

}

class PINNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;
  PINNumber({this.textEditingController, this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.0,
      height: 45.0,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: false,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8.0),
          border: outlineInputBorder,
          filled: true,
          fillColor: Color(0xffE9F2FF),
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Color(0xff2968E2),
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  KeyboardNumber({this.n, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffE9F2FF),
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0)
        ),
        height: 90.0,
        child: Text("$n", textAlign: TextAlign.center, 
        style: TextStyle(
          fontSize: 24*MediaQuery.of(context).textScaleFactor,
          color: Color(0xff2968E2),
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
  }
}

