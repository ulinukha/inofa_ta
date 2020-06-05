import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inofa/api/api.dart';

class UserModels{
  int id_pengguna;
  String id;
  String display_name;
  String profile_picture;
  String pendidikan;
  String email;
  String tgl_lahir;
  String website;
  String no_telp;
  String short_desc;
  double longitude;
  double latitude;
  int rating;
  int status;
  int id_pendidikan;

  UserModels({
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
    this.longitude,
    this.latitude,
    this.rating,
    this.status,
    this.id_pendidikan,
  });

  factory UserModels.fromJson(Map<String, dynamic> json) {
    return new UserModels(
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
      longitude: json['longitude'],
      latitude: json['latitude'],
      rating: json['rating'],
      status: json['status'],
      id_pendidikan: json['id_pendidikan'],
    );
  }

  static Future<UserModels> getDataUser() async{
    var response = await http.get(BaseUrl.dataUser+'fikri.ulinukha@gmail.com');
    var jsonObject = json.decode(response.body);
    var data = (jsonObject as Map<String, dynamic>);

    return UserModels.fromJson(data);
  }

}