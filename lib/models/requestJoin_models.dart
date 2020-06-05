class ListRequestJoin {
  final int id_subscription;
  final int pengguna_id;
  final int inovasi_id;
  final String status;
  final String join_by;
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

  ListRequestJoin({
    this.id_subscription,
    this.pengguna_id,
    this.inovasi_id,
    this.status,
    this.join_by,
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
  });

  factory ListRequestJoin.fromJson(Map<String, dynamic> json) {
    return new ListRequestJoin(
      id_subscription: json['id_subscription'],
      pengguna_id: json['pengguna_id'],
      inovasi_id : json['inovasi_id'],
      status: json['status'],
      join_by: json['join_by'],
      id_pengguna : json['id_pengguna'],
      id: json['id'],
      display_name: json['display_name'],
      profile_picture: json['profile_picture'],
      pendidikan : json['pendidikan'],
      email: json['email'],
      tgl_lahir: json['tgl_lahir'],
      website: json['website'],
      no_telp : json['no_telp'],
      short_desc : json['short_desc'],
    );
  }
}