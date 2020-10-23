class ListInvitation{
  final int id_subscription;
  final int pengguna_id;
  final int inovasi_id;
  final String status;
  final String join_by;
  final int id_kategori;
  final String kategori;
  final int jumlah;
  final String judul;
  final String tagline;
  final String description;
  final String thumbnail;

  ListInvitation ({
    this.id_subscription, this.pengguna_id, this.inovasi_id,
    this.status,          this.join_by,     this.id_kategori,
    this.kategori,        this.jumlah,      this.judul,
    this.tagline,         this.description, this.thumbnail
  });

  factory ListInvitation.fromJson(Map<String, dynamic> json){
    return new ListInvitation(
      id_subscription: json['id_subscription'],
      pengguna_id: json['pengguna_id'],
      inovasi_id: json['inovasi_id'],
      status: json['status'],
      join_by: json['join_by'],
      id_kategori: json['id_kategori'],
      kategori: json['kategori'],
      jumlah: json['jumlah'],
      judul: json['judul'],
      tagline: json['tagline'],
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }
}