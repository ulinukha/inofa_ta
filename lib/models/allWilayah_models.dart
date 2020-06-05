class AllWilayah {
  String propinsi;
  int id_wilayah;
  double longitude;
  double latitude;

  AllWilayah ({
    this.propinsi,
    this.id_wilayah,
    this.longitude,
    this.latitude
  });

  factory AllWilayah.fromJson(Map<String, dynamic> json){
    return new AllWilayah(
      propinsi : json['propinsi'],
      id_wilayah: json['id_wilayah'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}