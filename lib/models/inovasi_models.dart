class ListInovasi{
  final int id_inovasi;
  final int pengguna_id;
  final String display_name;
  final String profile_picture;
  final String judul;
  final String tagline;
  final String description;
  final String thumbnail;
  final String kategori;
  final String created_at;
  final int jumlah;
  final int inovasiId;
  bool isSelected=false;

  ListInovasi({
    this.id_inovasi,
    this.pengguna_id,
    this.display_name,
    this.profile_picture,
    this.judul,
    this.tagline,
    this.description,
    this.thumbnail,
    this.kategori,
    this.created_at,
    this.jumlah,
    this.inovasiId
  });

  factory ListInovasi.fromJson(Map<String, dynamic> json){
    return new ListInovasi(
      id_inovasi : json['id_inovasi'],
      pengguna_id: json['pengguna_id'],
      display_name: json['display_name'],
      profile_picture: json['profile_picture'],
      judul: json['judul'],
      tagline: json['tagline'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      kategori: json['kategori'],
      created_at: json['created_at'],
      jumlah: json['jml_anggota'],
      inovasiId: json['inovasi_id']
    );
  }

}