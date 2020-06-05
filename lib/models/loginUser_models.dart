import 'dart:convert';

import 'package:inofa/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser{
  final User user;

  LoginUser({
    this.user
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return new LoginUser(
      user: User.fromJson(json['user'])
    );
  }

  static Future<LoginUser> getDataUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var response = await http.get(BaseUrl.dataUser+email);
    var jsonObject = json.decode(response.body);
    var data = (jsonObject as Map<String, dynamic>);

    return LoginUser.fromJson(data);
  }
}

class User{
  final int id_pengguna;
  final String id;
  final String display_name;
  final String profile_picture;
  final String pendidikan;
  final String email;
  final String tgl_lahir;
  final String website;
  final String no_telp;
  final String short_desc;
  final int rating;
  final String token;
  final int id_pendidikan;

  User({
    this.id_pengguna,
    this.id,
    this.display_name,
    this.profile_picture,
    this.pendidikan,
    this.email,
    this.tgl_lahir,
    this.website,
    this.no_telp,
    this.short_desc,
    this.rating,
    this.token,
    this.id_pendidikan
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id_pengguna: json['id_pengguna'],
      id: json['id'],
      display_name: json['display_name'],
      profile_picture: json['profile_picture'],
      pendidikan: json['pendidikan'],
      email: json['email'],
      tgl_lahir: json['tgl_lahir'],
      website: json['website'],
      no_telp: json['no_telp'],
      short_desc: json['short_desc'],
      rating: json['rating'],
      token: json['token'],
      id_pendidikan: json['id_pendidikan'],

    );
  } 
}