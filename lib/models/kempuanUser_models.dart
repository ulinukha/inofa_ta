class KemampuanUser {
  int id_mapping;
  int pengguna_id;
  int kemampuan_id;
  String kemampuan;

  KemampuanUser ({
    this.id_mapping,
    this.pengguna_id,
    this.kemampuan_id,
    this.kemampuan
  });

  factory KemampuanUser.fromJson(Map<String, dynamic> json){
    return new KemampuanUser(
      id_mapping: json['id_mapping'],
      pengguna_id: json['pengguna_id'],
      kemampuan_id: json['kemampuan_id'],
      kemampuan: json['kemampuan'],
    );
  }
}