import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_otp/flutter_otp.dart';
import 'package:inofa/currentTab.dart';

class OtpPage extends StatefulWidget{
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        child: OtpScreen(),
      ),
    );
  }
}


class OtpScreen extends StatefulWidget{
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>{
  List<String> currentOtp = ["","","",""];
  TextEditingController otpOneController = TextEditingController();
  TextEditingController otpTwoController = TextEditingController();
  TextEditingController otpThreeController = TextEditingController();
  TextEditingController otpFourController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.transparent),
  );

  int otpIndex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
    else if (otpIndex == 4){
      setOtp(otpIndex, "");
      currentOtp[otpIndex - 1] = "";
      otpIndex--;
    }else {
      setOtp(otpIndex, "");
      currentOtp[otpIndex - 1] = "";
      otpIndex--;
    }
  }

  otpIndexSetup(String text) {
    if(otpIndex == 0)
    otpIndex = 1;
  else if(otpIndex < 4)
    otpIndex++;
  setOtp(otpIndex, text);
  currentOtp[otpIndex-1] = text;
  String strOtp = "";
  currentOtp.forEach((e){
    strOtp += e;
  });

  if(otpIndex == 4)
  print(strOtp);
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
              Text(
                " +62 123 456 789", 
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
              onPressed: () {
                Navigator.push(context,
                new MaterialPageRoute(
                  builder: (context) => new CurrentTab(),
                ),
                );
              },
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

