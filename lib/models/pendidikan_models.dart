class ListPendidikan {
  final int id_Pendidikan;
  final String pendidikan;

  ListPendidikan({
    this.id_Pendidikan, 
    this.pendidikan});

  factory ListPendidikan.fromJson(Map<String, dynamic> json) {
    return new ListPendidikan(
      id_Pendidikan : json['id_pendidikan'],
      pendidikan : json['pendidikan']
    );
  }
}