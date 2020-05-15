class ListKategori{
  final int id_kategori;
  final String kategori;
  final String kategori_thumbnail;

  ListKategori ({
    this.id_kategori,
    this.kategori,
    this.kategori_thumbnail
  });

  factory ListKategori.fromJson(Map<String, dynamic> json) {
    return new ListKategori(
      id_kategori: json['id_kategori'],
      kategori: json['kategori'],
      kategori_thumbnail: json['kategori_thumbnail']
    );
  }
}