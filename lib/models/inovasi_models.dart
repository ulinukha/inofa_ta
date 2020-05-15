class ListInovasi{
  final int id_inovasi;
  final int pengguna_id;
  final String judul;
  final String tagline;
  final int kategori_id;
  final String description;
  final String thumbnail;
  final int status;
  final String created_at;

  ListInovasi({
    this.id_inovasi,
    this.pengguna_id,
    this.judul,
    this.tagline,
    this.kategori_id,
    this.description,
    this.thumbnail,
    this.status,
    this.created_at
  });

  factory ListInovasi.fromJson(Map<String, dynamic> json){
    return new ListInovasi(
      id_inovasi : json['id_inovasi'],
      pengguna_id: json['pengguna_id'],
      judul: json['judul'],
      tagline: json['tagline'],
      kategori_id: json['kategori_id'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      status: json['status'],
      created_at: json['created_at']
    );
  }

}