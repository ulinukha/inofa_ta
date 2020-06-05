import 'package:flutter/material.dart';
import 'package:inofa/currentTab.dart';
import 'package:inofa/search/show_all_kategori.dart';
import 'package:inofa/splash_screen.dart';
import 'package:inofa/onBoarding.dart';
import 'package:inofa/register/sign_in.dart';
import 'package:inofa/register/number.dart';
import 'package:inofa/register/otp_page.dart';
import 'package:inofa/tab/tab_home.dart';
import 'package:inofa/tab/tab_chat.dart';
import 'package:inofa/tab/tab_notification.dart';
import 'package:inofa/tab/tab_profile.dart';
import 'package:inofa/user_details/add_kemampuan.dart';
import 'package:inofa/user_details/edit_profile_option.dart';
import 'package:inofa/user_details/edit_profile.dart';
import 'package:inofa/user_details/update_profile_start.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/' : (context) => SplachScreen(),
        '/Onboarding' : (context) => OnBoarding(),
        '/SignIn' : (context) => SignIn(),
        '/updateProfile' : (context) => UpdateProfileStart(),
        '/Number' : (context) => Number(),
        '/Otp' : (context) => OtpScreen(),
        '/CurrentTab': (context) => CurrentTab(),
        '/Home' : (context) => Home(),
        '/Chat' : (context) => Chat(),
        '/Notification' : (context) => Notif(),
        '/Profile' : (context) => Profile(),
        '/serchKategori' : (context) => ShowAll(),
        '/AddSkill' : (context) => AddKemampuan(),
        '/EditProfileOption' : (context) => EditProfileOption(),
        '/EditProfil' : (context) => EditProfil()
      },
    );
  }
}

